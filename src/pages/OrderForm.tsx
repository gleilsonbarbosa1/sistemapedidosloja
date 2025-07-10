import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import supabase from '../lib/supabase';
import { useAuth } from '../hooks/useAuth';
import toast from 'react-hot-toast';
import { 
  ArrowLeft, 
  Plus, 
  Minus, 
  Trash, 
  Save,
  Receipt
} from 'lucide-react';

interface MenuItem {
  id: string;
  name: string;
  price: number;
  category: string;
  available: boolean;
}

interface OrderItem {
  id?: string;
  menu_item_id: string;
  quantity: number;
  unit_price: number;
  name: string;
  subtotal: number;
}

interface Category {
  id: string;
  name: string;
}

type OrderType = 'dine_in' | 'takeout' | 'delivery';

const OrderForm: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { user } = useAuth();
  const isEditing = !!id;

  // Order state
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [customer, setCustomer] = useState<string>('');
  const [tableNumber, setTableNumber] = useState<string>('');
  const [orderType, setOrderType] = useState<OrderType>('dine_in');
  const [note, setNote] = useState<string>('');
  const [status, setStatus] = useState<'pending' | 'completed' | 'cancelled'>('pending');

  // Menu state
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [loading, setLoading] = useState<boolean>(true);
  const [saving, setSaving] = useState<boolean>(false);

  // Calculate totals
  const subtotal = orderItems.reduce((sum, item) => sum + item.subtotal, 0);
  const tax = subtotal * 0.0875; // 8.75% tax rate
  const total = subtotal + tax;

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      try {
        // Fetch menu items
        const { data: menuData, error: menuError } = await supabase
          .from('menu_items')
          .select('*')
          .eq('available', true)
          .order('name');

        if (menuError) throw menuError;
        setMenuItems(menuData || []);

        // Fetch categories
        const { data: categoryData, error: categoryError } = await supabase
          .from('categories')
          .select('*')
          .order('name');

        if (categoryError) throw categoryError;
        setCategories(categoryData || []);

        // If editing, fetch order details
        if (isEditing) {
          const { data: orderData, error: orderError } = await supabase
            .from('orders')
            .select('*')
            .eq('id', id)
            .single();

          if (orderError) throw orderError;

          if (orderData) {
            setCustomer(orderData.customer_name);
            setTableNumber(orderData.table_number?.toString() || '');
            setOrderType(orderData.order_type);
            setNote(orderData.notes || '');
            setStatus(orderData.status);

            // Fetch order items
            const { data: orderItemsData, error: orderItemsError } = await supabase
              .from('order_items')
              .select('*, menu_items(name)')
              .eq('order_id', id);

            if (orderItemsError) throw orderItemsError;

            if (orderItemsData) {
              const items = orderItemsData.map(item => ({
                id: item.id,
                menu_item_id: item.menu_item_id,
                quantity: item.quantity,
                unit_price: item.unit_price,
                name: item.menu_items?.name || 'Unknown Item',
                subtotal: item.quantity * item.unit_price
              }));
              setOrderItems(items);
            }
          }
        }
      } catch (error) {
        console.error('Error fetching data:', error);
        toast.error('Failed to load data');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [id, isEditing]);

  const filteredMenuItems = selectedCategory === 'all'
    ? menuItems
    : menuItems.filter(item => item.category === selectedCategory);

  const handleAddItem = (menuItem: MenuItem) => {
    // Check if the item is already in the order
    const existingItemIndex = orderItems.findIndex(item => item.menu_item_id === menuItem.id);

    if (existingItemIndex >= 0) {
      // Increment quantity if already in order
      const updatedItems = [...orderItems];
      updatedItems[existingItemIndex].quantity += 1;
      updatedItems[existingItemIndex].subtotal = updatedItems[existingItemIndex].quantity * updatedItems[existingItemIndex].unit_price;
      setOrderItems(updatedItems);
    } else {
      // Add new item to order
      const newItem: OrderItem = {
        menu_item_id: menuItem.id,
        quantity: 1,
        unit_price: menuItem.price,
        name: menuItem.name,
        subtotal: menuItem.price
      };
      setOrderItems([...orderItems, newItem]);
    }

    toast.success(`Added ${menuItem.name} to order`);
  };

  const handleUpdateQuantity = (index: number, newQuantity: number) => {
    if (newQuantity < 1) return;

    const updatedItems = [...orderItems];
    updatedItems[index].quantity = newQuantity;
    updatedItems[index].subtotal = newQuantity * updatedItems[index].unit_price;
    setOrderItems(updatedItems);
  };

  const handleRemoveItem = (index: number) => {
    const updatedItems = [...orderItems];
    updatedItems.splice(index, 1);
    setOrderItems(updatedItems);
  };

  const validateForm = () => {
    if (!customer.trim()) {
      toast.error('Please enter customer name');
      return false;
    }

    if (orderType === 'dine_in' && !tableNumber) {
      toast.error('Please enter table number for dine-in orders');
      return false;
    }

    if (orderItems.length === 0) {
      toast.error('Please add at least one item to the order');
      return false;
    }

    return true;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;
    
    setSaving(true);
    
    try {
      if (isEditing) {
        // Update existing order
        const { error: orderError } = await supabase
          .from('orders')
          .update({
            customer_name: customer,
            table_number: orderType === 'dine_in' ? parseInt(tableNumber) : null,
            order_type: orderType,
            notes: note,
            status: status,
            total_amount: total,
            updated_at: new Date().toISOString(),
            updated_by: user?.id
          })
          .eq('id', id);

        if (orderError) throw orderError;

        // Delete existing order items
        const { error: deleteError } = await supabase
          .from('order_items')
          .delete()
          .eq('order_id', id);

        if (deleteError) throw deleteError;

        // Insert new order items
        const orderItemsToInsert = orderItems.map(item => ({
          order_id: id,
          menu_item_id: item.menu_item_id,
          quantity: item.quantity,
          unit_price: item.unit_price
        }));

        const { error: insertError } = await supabase
          .from('order_items')
          .insert(orderItemsToInsert);

        if (insertError) throw insertError;

        toast.success('Order updated successfully');
      } else {
        // Create new order
        const { data: orderData, error: orderError } = await supabase
          .from('orders')
          .insert([{
            customer_name: customer,
            table_number: orderType === 'dine_in' ? parseInt(tableNumber) : null,
            order_type: orderType,
            notes: note,
            status: 'pending',
            total_amount: total,
            created_by: user?.id
          }])
          .select();

        if (orderError) throw orderError;

        if (!orderData || orderData.length === 0) {
          throw new Error('Failed to create order');
        }

        const newOrderId = orderData[0].id;

        // Insert order items
        const orderItemsToInsert = orderItems.map(item => ({
          order_id: newOrderId,
          menu_item_id: item.menu_item_id,
          quantity: item.quantity,
          unit_price: item.unit_price
        }));

        const { error: insertError } = await supabase
          .from('order_items')
          .insert(orderItemsToInsert);

        if (insertError) throw insertError;

        toast.success('Order created successfully');
      }

      navigate('/orders');
    } catch (error) {
      console.error('Error saving order:', error);
      toast.error('Failed to save order');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="w-12 h-12 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6 flex items-center">
        <button
          onClick={() => navigate('/orders')}
          className="mr-4 text-gray-500 hover:text-gray-700"
        >
          <ArrowLeft className="h-5 w-5" />
        </button>
        <h1 className="text-2xl font-bold text-gray-900">
          {isEditing ? 'Edit Order' : 'New Order'}
        </h1>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Side - Menu Items */}
        <div className="lg:col-span-2">
          <div className="bg-white rounded-lg shadow border border-gray-100 overflow-hidden">
            <div className="px-4 py-3 border-b border-gray-200">
              <h3 className="font-semibold text-gray-800">Menu Items</h3>
            </div>

            {/* Category Tabs */}
            <div className="border-b border-gray-200 overflow-x-auto">
              <div className="flex min-w-max">
                <button
                  onClick={() => setSelectedCategory('all')}
                  className={`px-4 py-2 font-medium text-sm whitespace-nowrap ${
                    selectedCategory === 'all'
                      ? 'border-b-2 border-blue-500 text-blue-600'
                      : 'text-gray-500 hover:text-gray-700'
                  }`}
                >
                  All Items
                </button>
                {categories.map(category => (
                  <button
                    key={category.id}
                    onClick={() => setSelectedCategory(category.id)}
                    className={`px-4 py-2 font-medium text-sm whitespace-nowrap ${
                      selectedCategory === category.id
                        ? 'border-b-2 border-blue-500 text-blue-600'
                        : 'text-gray-500 hover:text-gray-700'
                    }`}
                  >
                    {category.name}
                  </button>
                ))}
              </div>
            </div>

            {/* Menu Items Grid */}
            <div className="p-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 max-h-96 overflow-y-auto">
              {filteredMenuItems.length > 0 ? (
                filteredMenuItems.map(item => (
                  <div
                    key={item.id}
                    className="border rounded-lg p-3 cursor-pointer hover:bg-gray-50 transition-colors"
                    onClick={() => handleAddItem(item)}
                  >
                    <div className="font-medium">{item.name}</div>
                    <div className="flex justify-between items-center mt-2">
                      <span className="text-sm text-gray-500">
                        {categories.find(c => c.id === item.category)?.name}
                      </span>
                      <span className="font-semibold">${item.price.toFixed(2)}</span>
                    </div>
                  </div>
                ))
              ) : (
                <div className="col-span-full text-center py-4 text-gray-500">
                  No items available in this category
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Right Side - Order Summary */}
        <div className="lg:col-span-1">
          <form onSubmit={handleSubmit}>
            {/* Order Details */}
            <div className="bg-white rounded-lg shadow border border-gray-100 mb-6">
              <div className="px-4 py-3 border-b border-gray-200">
                <h3 className="font-semibold text-gray-800">Order Details</h3>
              </div>
              <div className="p-4 space-y-4">
                <div>
                  <label htmlFor="customer" className="block text-sm font-medium text-gray-700">Customer Name*</label>
                  <input
                    type="text"
                    id="customer"
                    value={customer}
                    onChange={(e) => setCustomer(e.target.value)}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
                    required
                  />
                </div>

                <div>
                  <label htmlFor="orderType" className="block text-sm font-medium text-gray-700">Order Type*</label>
                  <select
                    id="orderType"
                    value={orderType}
                    onChange={(e) => setOrderType(e.target.value as OrderType)}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
                    required
                  >
                    <option value="dine_in">Dine In</option>
                    <option value="takeout">Takeout</option>
                    <option value="delivery">Delivery</option>
                  </select>
                </div>

                {orderType === 'dine_in' && (
                  <div>
                    <label htmlFor="tableNumber" className="block text-sm font-medium text-gray-700">Table Number*</label>
                    <input
                      type="number"
                      id="tableNumber"
                      value={tableNumber}
                      onChange={(e) => setTableNumber(e.target.value)}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
                      min="1"
                      required
                    />
                  </div>
                )}

                <div>
                  <label htmlFor="note" className="block text-sm font-medium text-gray-700">Note</label>
                  <textarea
                    id="note"
                    value={note}
                    onChange={(e) => setNote(e.target.value)}
                    rows={2}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
                  />
                </div>

                {isEditing && (
                  <div>
                    <label htmlFor="status" className="block text-sm font-medium text-gray-700">Status</label>
                    <select
                      id="status"
                      value={status}
                      onChange={(e) => setStatus(e.target.value as 'pending' | 'completed' | 'cancelled')}
                      className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
                    >
                      <option value="pending">Pending</option>
                      <option value="completed">Completed</option>
                      <option value="cancelled">Cancelled</option>
                    </select>
                  </div>
                )}
              </div>
            </div>

            {/* Order Items */}
            <div className="bg-white rounded-lg shadow border border-gray-100 mb-6">
              <div className="px-4 py-3 border-b border-gray-200">
                <h3 className="font-semibold text-gray-800">Order Items</h3>
              </div>
              <div className="p-4">
                {orderItems.length > 0 ? (
                  <div className="divide-y divide-gray-200">
                    {orderItems.map((item, index) => (
                      <div key={index} className="py-3 flex items-center">
                        <div className="flex-1">
                          <div className="font-medium">{item.name}</div>
                          <div className="text-sm text-gray-500">${item.unit_price.toFixed(2)} each</div>
                        </div>
                        <div className="flex items-center">
                          <button
                            type="button"
                            onClick={() => handleUpdateQuantity(index, item.quantity - 1)}
                            className="text-gray-500 hover:text-gray-700"
                          >
                            <Minus className="h-4 w-4" />
                          </button>
                          <span className="mx-2 min-w-[2rem] text-center">{item.quantity}</span>
                          <button
                            type="button"
                            onClick={() => handleUpdateQuantity(index, item.quantity + 1)}
                            className="text-gray-500 hover:text-gray-700"
                          >
                            <Plus className="h-4 w-4" />
                          </button>
                          <button
                            type="button"
                            onClick={() => handleRemoveItem(index)}
                            className="ml-4 text-red-500 hover:text-red-700"
                          >
                            <Trash className="h-4 w-4" />
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-6 text-gray-500">
                    No items added to the order yet
                  </div>
                )}
              </div>
            </div>

            {/* Order Summary */}
            <div className="bg-white rounded-lg shadow border border-gray-100 mb-6">
              <div className="px-4 py-3 border-b border-gray-200">
                <h3 className="font-semibold text-gray-800">Order Summary</h3>
              </div>
              <div className="p-4">
                <div className="flex justify-between py-2">
                  <span className="text-gray-600">Subtotal</span>
                  <span className="font-medium">${subtotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between py-2">
                  <span className="text-gray-600">Tax (8.75%)</span>
                  <span className="font-medium">${tax.toFixed(2)}</span>
                </div>
                <div className="flex justify-between py-2 text-lg font-bold">
                  <span>Total</span>
                  <span>${total.toFixed(2)}</span>
                </div>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={saving || orderItems.length === 0}
              className="w-full flex justify-center items-center py-2 px-4 border border-transparent rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-blue-300 disabled:cursor-not-allowed"
            >
              {saving ? (
                <>
                  <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Saving...
                </>
              ) : (
                <>
                  <Save className="h-5 w-5 mr-2" />
                  {isEditing ? 'Update Order' : 'Create Order'}
                </>
              )}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default OrderForm;