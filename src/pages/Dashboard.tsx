import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Store, Share2, Trash2, DollarSign, Search, ChevronDown } from 'lucide-react';
import supabase from '../lib/supabase';
import toast from 'react-hot-toast';
import Timer from '../components/Timer';
import { useTimer } from '../hooks/useTimer';

interface Category {
  id: string;
  name: string;
}

interface Product {
  id: string;
  name: string;
  category_id: string;
}

interface OrderItem {
  product_id: string;
  quantity: number;
  status: 'full' | 'half' | 'empty';
  has_stock: boolean;
  notes: string;
}

interface ChecklistState {
  ar_desligado: boolean;
  freezer_fechado: boolean;
  lixo_retirado: boolean;
  piso_limpo: boolean;
  luzes_apagadas: boolean;
  caixa_fechado: boolean;
  portas_trancadas: boolean;
  freezer_cozinha_limpo: boolean;
  freezer_acai_limpo: boolean;
  freezer_sorvetes_limpo: boolean;
  freezer_sorvetes_preparado: boolean;
  carregador_desligado: boolean;
  banheiro_limpo: boolean;
  loucas_guardadas: boolean;
  tv_desligada: boolean;
}

const Dashboard: React.FC = () => {
  const navigate = useNavigate();
  const { startTimer, stopTimer, resetTimer, elapsedTime, formatTime } = useTimer();
  
  const [selectedStore, setSelectedStore] = useState<string>('');
  const [searchQuery, setSearchQuery] = useState('');
  const [categories, setCategories] = useState<Category[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [expandedCategories, setExpandedCategories] = useState<string[]>([]);
  const [orderItems, setOrderItems] = useState<Record<string, OrderItem>>({});
  const [loading, setLoading] = useState(true);
  const [dataError, setDataError] = useState<string | null>(null);
  const [checklist, setChecklist] = useState<ChecklistState>({
    ar_desligado: false,
    freezer_fechado: false,
    lixo_retirado: false,
    piso_limpo: false,
    luzes_apagadas: false,
    caixa_fechado: false,
    portas_trancadas: false,
    freezer_cozinha_limpo: false,
    freezer_acai_limpo: false,
    freezer_sorvetes_limpo: false,
    freezer_sorvetes_preparado: false,
    carregador_desligado: false,
    banheiro_limpo: false,
    loucas_guardadas: false,
    tv_desligada: false
  });

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      setDataError(null);
      
      try {
        console.log('Starting data fetch...');
        
        // Fetch categories
        const { data: categories, error: categoriesError } = await supabase
          .from('categories')
          .select('*')
          .order('order_index');
        
        if (categoriesError) {
          console.error('Error fetching categories:', categoriesError);
          setDataError(`Erro ao carregar categorias: ${categoriesError.message}`);
          return;
        }
        
        console.log('Categories loaded:', categories);
        setCategories(categories || []);
        setExpandedCategories((categories || []).map(cat => cat.id));

        // Fetch products
        const { data: products, error: productsError } = await supabase
          .from('products')
          .select('*')
          .order('name');
        
        if (productsError) {
          console.error('Error fetching products:', productsError);
          setDataError(`Erro ao carregar produtos: ${productsError.message}`);
          return;
        }
        
        console.log('Products loaded:', products);
        setProducts(products || []);

        // Fetch stores
        const { data: stores } = await supabase
          .from('stores')
          .select('*')
          .order('name');
        
        if (stores && stores.length > 0) {
          setSelectedStore(stores[0].id);
        }

        // Load saved draft
        const savedDraft = localStorage.getItem('orderDraft');
        if (savedDraft) {
          setOrderItems(JSON.parse(savedDraft));
        }
      } catch (error) {
        console.error('Erro ao carregar dados:', error);
        setDataError(`Erro geral: ${error instanceof Error ? error.message : 'Erro desconhecido'}`);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const toggleCategory = (categoryId: string) => {
    setExpandedCategories(prev => 
      prev.includes(categoryId)
        ? prev.filter(id => id !== categoryId)
        : [...prev, categoryId]
    );
  };

  const handleItemChange = (productId: string, field: keyof OrderItem, value: any) => {
    // Start timer when checking a checkbox
    if (field === 'quantity' && value > 0) {
      startTimer();
    }

    setOrderItems(prev => ({
      ...prev,
      [productId]: {
        ...prev[productId],
        [field]: value
      }
    }));
  };

  const handleChecklistChange = (field: keyof ChecklistState) => {
    // Start timer when checking any checklist item
    startTimer();
    
    setChecklist(prev => ({
      ...prev,
      [field]: !prev[field]
    }));
  };

  const saveDraft = () => {
    localStorage.setItem('orderDraft', JSON.stringify(orderItems));
    toast.success('Rascunho salvo com sucesso!');
  };

  const clearForm = () => {
    if (window.confirm('Tem certeza que deseja limpar o formulário?')) {
      setOrderItems({});
      setChecklist({
        ar_desligado: false,
        freezer_fechado: false,
        lixo_retirado: false,
        piso_limpo: false,
        luzes_apagadas: false,
        caixa_fechado: false,
        portas_trancadas: false,
        freezer_cozinha_limpo: false,
        freezer_acai_limpo: false,
        freezer_sorvetes_limpo: false,
        freezer_sorvetes_preparado: false,
        carregador_desligado: false,
        banheiro_limpo: false,
        loucas_guardadas: false,
        tv_desligada: false
      });
      localStorage.removeItem('orderDraft');
      toast.success('Formulário limpo com sucesso!');
    }
  };

  const getStatusEmoji = (status: string, hasStock: boolean) => {
    if (status === 'full') return hasStock ? '✅ Cheio - 📦 Em estoque' : '✅ Cheio - ⚠️ Fora de estoque';
    if (status === 'half') return hasStock ? '➗ Metade - 📦 Em estoque' : '➗ Metade - ⚠️ Fora de estoque';
    if (status === 'empty') return hasStock ? '❌ Vazio - 📦 Em estoque' : '❌ Vazio - ⚠️ Fora de estoque';
    return '⚠️ Bem pouco - ⚠️ Fora de estoque';
  };

  const shareOnWhatsApp = () => {
    // Stop the timer when sharing
    stopTimer();

    const groupedItems = Object.entries(orderItems)
      .filter(([_, item]) => item.quantity > 0)
      .reduce((acc, [productId, item]) => {
        const product = products.find(p => p.id === productId);
        const category = categories.find(c => c.id === product?.category_id);
        
        if (!acc[category?.id || '']) {
          acc[category?.id || ''] = {
            name: category?.name || 'Outros',
            items: []
          };
        }
        
        acc[category?.id || ''].items.push({
          name: product?.name || '',
          status: item.status,
          hasStock: item.has_stock,
          notes: item.notes
        });
        
        return acc;
      }, {} as Record<string, { name: string; items: Array<{ name: string; status: string; hasStock: boolean; notes: string }> }>);

    const currentDate = new Date().toLocaleDateString('pt-BR');
    const timeSpent = formatTime(elapsedTime);

    // Create checklist status section
    const checklistStatus = [
      ['Ar-condicionado desligado', checklist.ar_desligado],
      ['Freezer fechado', checklist.freezer_fechado],
      ['Lixo retirado', checklist.lixo_retirado],
      ['Piso limpo', checklist.piso_limpo],
      ['Luzes apagadas', checklist.luzes_apagadas],
      ['Caixa fechado', checklist.caixa_fechado],
      ['Portas trancadas', checklist.portas_trancadas],
      ['Freezer cozinha limpo', checklist.freezer_cozinha_limpo],
      ['Freezer açaí limpo', checklist.freezer_acai_limpo],
      ['Freezer sorvetes limpo', checklist.freezer_sorvetes_limpo],
      ['Freezer sorvetes preparado', checklist.freezer_sorvetes_preparado],
      ['Carregador desligado', checklist.carregador_desligado],
      ['Banheiro limpo', checklist.banheiro_limpo],
      ['Louças guardadas', checklist.loucas_guardadas],
      ['TV desligada', checklist.tv_desligada]
    ]
      .map(([label, checked]) => `${checked ? '✅' : '❌'} ${label}`)
      .join('\n');

    const message = `*CONTROLE DE ESTOQUE - ELITE AÇAÍ*\n📅 ${currentDate}\n⏱️ Tempo gasto: ${timeSpent}\n\n${Object.entries(groupedItems)
      .map(([_, category]) => {
        const items = category.items
          .map(item => {
            const statusLine = `*${item.name}*\n${getStatusEmoji(item.status, item.hasStock)}`;
            return item.notes ? `${statusLine}\n💭 _${item.notes}_` : statusLine;
          })
          .join('\n\n');

        return `📋 *${category.name.toUpperCase()}*\n${items}`;
      })
      .join('\n\n')}\n\n*CHECKLIST DE FECHAMENTO*\n${checklistStatus}`;

    const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
    const mobileUrl = `whatsapp://send?text=${encodeURIComponent(message)}`;
    const webUrl = `https://web.whatsapp.com/send?text=${encodeURIComponent(message)}`;
    
    if (isMobile) {
      window.location.href = mobileUrl;
      setTimeout(() => {
        window.open(webUrl, '_blank');
      }, 1000);
    } else {
      window.open(webUrl, '_blank');
    }

    // Reset timer after 2 seconds
    setTimeout(() => {
      resetTimer();
    }, 2000);
  };

  const filteredProducts = searchQuery
    ? products.filter(p => 
        p.name.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : products;

  if (loading) {
    return (
      <div className="min-h-screen bg-purple-600 flex items-center justify-center">
        <div className="text-center text-white">
          <div className="w-16 h-16 border-4 border-white border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p>Carregando dados...</p>
        </div>
      </div>
    );
  }

  if (dataError) {
    return (
      <div className="min-h-screen bg-purple-600 flex items-center justify-center">
        <div className="text-center text-white max-w-md mx-auto p-6">
          <div className="bg-red-500 rounded-full w-16 h-16 flex items-center justify-center mx-auto mb-4">
            <span className="text-2xl">⚠️</span>
          </div>
          <h2 className="text-xl font-bold mb-2">Erro ao Carregar Dados</h2>
          <p className="mb-4">{dataError}</p>
          <button 
            onClick={() => window.location.reload()}
            className="bg-white text-purple-600 px-4 py-2 rounded-md hover:bg-gray-100"
          >
            Tentar Novamente
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-purple-600 main-content">
      {/* Header */}
      <div className="bg-purple-600 pb-4">
        <div className="container mx-auto px-4 py-4">
          <div className="flex flex-col sm:flex-row justify-between items-center mb-4 gap-4">
            <div className="flex items-center text-white w-full sm:w-auto">
              <Store className="h-12 w-12 mr-4" />
              <div className="flex items-center gap-4">
                <div>
                  <h1 className="text-2xl sm:text-3xl font-bold uppercase">Sistema de Pedidos</h1>
                  <h2 className="text-lg sm:text-xl uppercase">Elite Açaí</h2>
                </div>
                <Timer />
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg p-4 shadow-lg">
            <div className="mb-4">
              <h3 className="text-lg font-semibold mb-3 uppercase">Selecione a Loja</h3>
              <div className="flex flex-wrap gap-4">
                <button
                  onClick={() => setSelectedStore('1')}
                  className={`flex items-center px-6 py-2 rounded-md border-2 ${
                    selectedStore === '1'
                      ? 'border-purple-500 text-purple-500 bg-purple-50'
                      : 'border-gray-300 text-gray-600'
                  }`}
                >
                  <Store className="h-5 w-5 mr-2" />
                  LOJA 1
                </button>
                <button
                  onClick={() => setSelectedStore('2')}
                  className={`flex items-center px-6 py-2 rounded-md border-2 ${
                    selectedStore === '2'
                      ? 'border-purple-500 text-purple-500 bg-purple-50'
                      : 'border-gray-300 text-gray-600'
                  }`}
                >
                  <Store className="h-5 w-5 mr-2" />
                  LOJA 2
                </button>
              </div>
            </div>

            <div className="flex flex-wrap gap-4">
              <button 
                onClick={clearForm}
                className="w-full sm:w-auto flex items-center justify-center px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 uppercase"
              >
                <Trash2 className="h-5 w-5 mr-2" />
                Limpar
              </button>
              <button 
                onClick={saveDraft}
                className="w-full sm:w-auto flex items-center justify-center px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 uppercase"
              >
                <Share2 className="h-5 w-5 mr-2" />
                Salvar Rascunho
              </button>
              <button 
                onClick={shareOnWhatsApp}
                className="w-full sm:w-auto flex items-center justify-center px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 uppercase"
              >
                <Share2 className="h-5 w-5 mr-2" />
                Compartilhar no WhatsApp
              </button>
              <button 
                onClick={() => navigate('/cash-closing')}
                className="w-full sm:w-auto flex items-center justify-center px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 uppercase"
              >
                <DollarSign className="h-5 w-5 mr-2" />
                Fechamento de Caixa
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Main content */}
      <div className="container mx-auto px-4 py-6 pb-20 mobile-spacing">
        <div className="bg-white rounded-lg p-4 shadow-lg">
          {/* Search bar */}
          <div className="mb-6">
            <div className="relative">
              <input
                type="text"
                placeholder="BUSCAR PRODUTOS..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full px-4 py-2 border border-gray-300 rounded-md pl-10 uppercase"
              />
              <Search className="absolute left-3 top-2.5 text-gray-400 h-5 w-5" />
            </div>
          </div>

          {/* Categories and Products */}
          <div className="space-y-4">
            {categories.length === 0 && !loading && (
              <div className="text-center py-8 text-gray-500">
                <p>Nenhuma categoria encontrada.</p>
                <p className="text-sm mt-2">Verifique se as categorias estão cadastradas no banco de dados.</p>
              </div>
            )}
            
            {categories.map(category => {
              const categoryProducts = filteredProducts.filter(p => p.category_id === category.id);
              
              console.log(`Category ${category.name}:`, categoryProducts);

              return (
                <div key={category.id} className="border rounded-md overflow-visible">
                  <button
                    onClick={() => toggleCategory(category.id)}
                    className="w-full px-4 py-3 flex items-center justify-between bg-gray-50 hover:bg-gray-100 transition-colors rounded-t-md focus:outline-none focus:ring-2 focus:ring-purple-500"
                  >
                    <h3 className="text-lg font-semibold uppercase">{category.name}</h3>
                    <ChevronDown 
                      className={`h-5 w-5 text-gray-500 transition-transform duration-200 ${
                        expandedCategories.includes(category.id) ? 'transform rotate-180' : ''
                      }`}
                    />
                  </button>
                  
                  {expandedCategories.includes(category.id) && (
                    <div className="p-4 overflow-visible">
                      {categoryProducts.length === 0 ? (
                        <div className="text-center py-4 text-gray-500">
                          <p>Nenhum produto encontrado nesta categoria.</p>
                        </div>
                      ) : (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {categoryProducts.map(product => {
                          const item = orderItems[product.id] || {
                            product_id: product.id,
                            quantity: 0,
                            status: 'full' as const,
                            has_stock: false,
                            notes: ''
                          };

                          return (
                            <div key={product.id} className="border rounded-lg p-4 bg-white shadow-sm hover:shadow-md transition-shadow">
                              <div className="flex items-center justify-between mb-3">
                                <label className="flex items-center space-x-3">
                                  <input
                                    type="checkbox"
                                    checked={item.quantity > 0}
                                    onChange={(e) => handleItemChange(product.id, 'quantity', e.target.checked ? 1 : 0)}
                                    className="form-checkbox h-5 w-5 text-purple-600"
                                  />
                                  <span className="text-gray-700 font-medium uppercase">{product.name}</span>
                                </label>
                                {item.quantity > 0 && (
                                  <div className="flex items-center space-x-2">
                                    <button
                                      onClick={() => handleItemChange(product.id, 'quantity', Math.max(0, item.quantity - 1))}
                                      className="p-1 text-gray-500 hover:text-gray-700"
                                    >
                                      -
                                    </button>
                                    <span className="w-8 text-center">{item.quantity}</span>
                                    <button
                                      onClick={() => handleItemChange(product.id, 'quantity', item.quantity + 1)}
                                      className="p-1 text-gray-500 hover:text-gray-700"
                                    >
                                      +
                                    </button>
                                  </div>
                                )}
                              </div>

                              {item.quantity > 0 && (
                                <div className="space-y-3">
                                  <div className="flex flex-wrap gap-2 sm:gap-4">
                                    <label className="flex items-center space-x-2">
                                      <input
                                        type="radio"
                                        name={`status-${product.id}`}
                                        value="full"
                                        checked={item.status === 'full'}
                                        onChange={(e) => handleItemChange(product.id, 'status', e.target.value)}
                                        className="text-purple-600"
                                      />
                                      <span className="uppercase">Cheio</span>
                                    </label>
                                    <label className="flex items-center space-x-2">
                                      <input
                                        type="radio"
                                        name={`status-${product.id}`}
                                        value="half"
                                        checked={item.status === 'half'}
                                        onChange={(e) => handleItemChange(product.id, 'status', e.target.value)}
                                        className="text-purple-600"
                                      />
                                      <span className="uppercase">Metade</span>
                                    </label>
                                    <label className="flex items-center space-x-2">
                                      <input
                                        type="radio"
                                        name={`status-${product.id}`}
                                        value="empty"
                                        checked={item.status === 'empty'}
                                        onChange={(e) => handleItemChange(product.id, 'status', e.target.value)}
                                        className="text-purple-600"
                                      />
                                      <span className="uppercase">Vazio</span>
                                    </label>
                                  </div>

                                  <label className="flex items-center space-x-2">
                                    <input
                                      type="checkbox"
                                      checked={item.has_stock}
                                      onChange={(e) => handleItemChange(product.id, 'has_stock', e.target.checked)}
                                      className="form-checkbox h-5 w-5 text-purple-600"
                                    />
                                    <span className="uppercase">Tem no estoque</span>
                                  </label>

                                  {item.has_stock && (
                                    <textarea
                                      value={item.notes}
                                      onChange={(e) => handleItemChange(product.id, 'notes', e.target.value)}
                                      placeholder="OBSERVAÇÕES..."
                                      className="w-full p-2 border rounded-md text-sm uppercase"
                                      rows={2}
                                    />
                                  )}
                                </div>
                              )}
                            </div>
                          );
                        })}
                      </div>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
            
            {/* Debug information - remove in production */}
            {!loading && (
              <div className="mt-8 p-4 bg-gray-100 rounded-lg text-sm text-gray-600">
                <p><strong>Debug Info:</strong></p>
                <p>Total categorias: {categories.length}</p>
                <p>Total produtos: {products.length}</p>
                <p>Produtos filtrados: {filteredProducts.length}</p>
                <p>Busca ativa: "{searchQuery}"</p>
              </div>
            )}
          </div>

          {/* Checklist Section */}
          <div className="mt-8 bg-gray-50 rounded-lg p-4 border checklist-section">
            <h3 className="text-lg font-semibold mb-4 uppercase">Checklist de Fechamento</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div>
                <h4 className="font-medium mb-2 uppercase">Verificações Gerais</h4>
                <div className="space-y-3">
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.ar_desligado}
                      onChange={() => handleChecklistChange('ar_desligado')}
                      className="form-checkbox h-5 w-5 text-purple-600 flex-shrink-0"
                    />
                    <span className="uppercase">Ar-condicionado desligado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.freezer_fechado}
                      onChange={() => handleChecklistChange('freezer_fechado')}
                      className="form-checkbox h-5 w-5 text-purple-600 flex-shrink-0"
                    />
                    <span className="uppercase">Freezer fechado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.lixo_retirado}
                      onChange={() => handleChecklistChange('lixo_retirado')}
                      className="form-checkbox h-5 w-5 text-purple-600 flex-shrink-0"
                    />
                    <span className="uppercase">Lixo retirado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.piso_limpo}
                      onChange={() => handleChecklistChange('piso_limpo')}
                      className="form-checkbox h-5 w-5 text-purple-600 flex-shrink-0"
                    />
                    <span className="uppercase">Piso limpo</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.luzes_apagadas}
                      onChange={() => handleChecklistChange('luzes_apagadas')}
                      className="form-checkbox h-5 w-5 text-purple-600 flex-shrink-0"
                    />
                    <span className="uppercase">Luzes apagadas</span>
                  </label>
                </div>
              </div>

              <div>
                <h4 className="font-medium mb-2 uppercase">Limpeza e Organização</h4>
                <div className="space-y-3">
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.freezer_cozinha_limpo}
                      onChange={() => handleChecklistChange('freezer_cozinha_limpo')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Freezer cozinha limpo</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.freezer_acai_limpo}
                      onChange={() => handleChecklistChange('freezer_acai_limpo')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Freezer açaí limpo</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.freezer_sorvetes_limpo}
                      onChange={() => handleChecklistChange('freezer_sorvetes_limpo')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Freezer sorvetes limpo</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.freezer_sorvetes_preparado}
                      onChange={() => handleChecklistChange('freezer_sorvetes_preparado')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Freezer sorvetes preparado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.banheiro_limpo}
                      onChange={() => handleChecklistChange('banheiro_limpo')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Banheiro limpo</span>
                  </label>
                </div>
              </div>

              <div>
                <h4 className="font-medium mb-2 uppercase">Verificações Finais</h4>
                <div className="space-y-3">
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.caixa_fechado}
                      onChange={() => handleChecklistChange('caixa_fechado')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Caixa fechado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.portas_trancadas}
                      onChange={() => handleChecklistChange('portas_trancadas')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Portas trancadas</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.carregador_desligado}
                      onChange={() => handleChecklistChange('carregador_desligado')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Carregador desligado</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.loucas_guardadas}
                      onChange={() => handleChecklistChange('loucas_guardadas')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">Louças guardadas</span>
                  </label>
                  <label className="flex items-center space-x-3">
                    <input
                      type="checkbox"
                      checked={checklist.tv_desligada}
                      onChange={() => handleChecklistChange('tv_desligada')}
                      className="form-checkbox h-5 w-5 text-purple-600"
                    />
                    <span className="uppercase">TV desligada</span>
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;