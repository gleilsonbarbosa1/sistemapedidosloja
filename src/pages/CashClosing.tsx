import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/useAuth';
import { ArrowLeft, Save, Share2 } from 'lucide-react';
import supabase from '../lib/supabase';
import toast from 'react-hot-toast';

const CashClosing: React.FC = () => {
  const navigate = useNavigate();
  const {user} = useAuth();
  const [totalAmount, setTotalAmount] = useState<string>('');
  const [cashLeftAmount, setCashLeftAmount] = useState<string>('');
  const [deliveryAmount, setDeliveryAmount] = useState<string>('');
  const [foodAmount, setFoodAmount] = useState<string>('');
  const [dailyPurchaseAmount, setDailyPurchaseAmount] = useState<string>('');
  const [attendant, setAttendant] = useState<string>('');
  const [notes, setNotes] = useState<string>('');
  const [saving, setSaving] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!totalAmount || !attendant) {
      toast.error('Por favor, preencha os campos obrigatórios');
      return;
    }

    setSaving(true);
    
    try {
      const { error } = await supabase
        .from('cash_closings')
        .insert({
          store_id: '1', // TODO: usar a loja selecionada
          total_amount: parseFloat(totalAmount),
          cash_left_amount: cashLeftAmount ? parseFloat(cashLeftAmount) : 0,
          delivery_amount: deliveryAmount ? parseFloat(deliveryAmount) : 0,
          food_amount: foodAmount ? parseFloat(foodAmount) : 0,
          daily_purchase_amount: dailyPurchaseAmount ? parseFloat(dailyPurchaseAmount) : 0,
          attendant: attendant,
          date: new Date().toISOString().split('T')[0],
          created_by: user?.id,
          notes
        });

      if (error) throw error;

      toast.success('Fechamento de caixa salvo com sucesso!');
      navigate('/');
    } catch (error) {
      console.error('Erro ao salvar fechamento:', error);
      toast.error('Erro ao salvar fechamento de caixa');
    } finally {
      setSaving(false);
    }
  };

  const shareOnWhatsApp = () => {
    const message = `*Fechamento de Caixa - Elite Açaí*\n\n` +
      `Atendente: ${attendant}\n` +
      `Valor Total do Caixa: R$ ${totalAmount}\n` +
      `Valor deixado no Caixa: R$ ${cashLeftAmount || '0'}\n` +
      `Valor do Entregador: R$ ${deliveryAmount || '0'}\n` +
      `Valor do Lanche: R$ ${foodAmount || '0'}\n` +
      `Compra do Dia: R$ ${dailyPurchaseAmount || '0'}\n` +
      (notes ? `\nObservações: ${notes}` : '');

    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(message)}`;
    window.open(whatsappUrl, '_blank');
  };

  return (
    <div className="min-h-screen bg-gray-100 p-4 sm:p-6 lg:p-8">
      <div className="max-w-2xl mx-auto">
        <button
          onClick={() => navigate('/')}
          className="text-gray-600 mb-6 flex items-center hover:text-gray-900"
        >
          <ArrowLeft className="h-5 w-5 mr-2" />
          Voltar
        </button>

        <div className="bg-white rounded-lg p-4 sm:p-6 shadow-lg">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">Fechamento de Caixa</h1>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
              <div className="sm:col-span-2">
                <label htmlFor="attendant" className="block text-sm font-medium text-gray-700">
                  Atendente*
                </label>
                <input
                  type="text"
                  id="attendant"
                  value={attendant}
                  onChange={(e) => setAttendant(e.target.value)}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                  required
                />
              </div>

              <div>
                <label htmlFor="totalAmount" className="block text-sm font-medium text-gray-700">
                  Valor Total do Caixa*
                </label>
                <div className="mt-1 relative rounded-md shadow-sm">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="text-gray-500 sm:text-sm">R$</span>
                  </div>
                  <input
                    type="number"
                    id="totalAmount"
                    step="0.01"
                    min="0"
                    value={totalAmount}
                    onChange={(e) => setTotalAmount(e.target.value)}
                    className="focus:ring-purple-500 focus:border-purple-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md"
                    placeholder="0.00"
                    required
                  />
                </div>
              </div>

              <div>
                <label htmlFor="cashLeftAmount" className="block text-sm font-medium text-gray-700">
                  Valor deixado no Caixa
                </label>
                <div className="mt-1 relative rounded-md shadow-sm">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="text-gray-500 sm:text-sm">R$</span>
                  </div>
                  <input
                    type="number"
                    id="cashLeftAmount"
                    step="0.01"
                    min="0"
                    value={cashLeftAmount}
                    onChange={(e) => setCashLeftAmount(e.target.value)}
                    className="focus:ring-purple-500 focus:border-purple-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md"
                    placeholder="0.00"
                  />
                </div>
              </div>

              <div>
                <label htmlFor="deliveryAmount" className="block text-sm font-medium text-gray-700">
                  Valor do Entregador
                </label>
                <div className="mt-1 relative rounded-md shadow-sm">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="text-gray-500 sm:text-sm">R$</span>
                  </div>
                  <input
                    type="number"
                    id="deliveryAmount"
                    step="0.01"
                    min="0"
                    value={deliveryAmount}
                    onChange={(e) => setDeliveryAmount(e.target.value)}
                    className="focus:ring-purple-500 focus:border-purple-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md"
                    placeholder="0.00"
                  />
                </div>
              </div>

              <div>
                <label htmlFor="foodAmount" className="block text-sm font-medium text-gray-700">
                  Valor do Lanche
                </label>
                <div className="mt-1 relative rounded-md shadow-sm">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="text-gray-500 sm:text-sm">R$</span>
                  </div>
                  <input
                    type="number"
                    id="foodAmount"
                    step="0.01"
                    min="0"
                    value={foodAmount}
                    onChange={(e) => setFoodAmount(e.target.value)}
                    className="focus:ring-purple-500 focus:border-purple-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md"
                    placeholder="0.00"
                  />
                </div>
              </div>

              <div>
                <label htmlFor="dailyPurchaseAmount" className="block text-sm font-medium text-gray-700">
                  Compra do Dia
                </label>
                <div className="mt-1 relative rounded-md shadow-sm">
                  <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span className="text-gray-500 sm:text-sm">R$</span>
                  </div>
                  <input
                    type="number"
                    id="dailyPurchaseAmount"
                    step="0.01"
                    min="0"
                    value={dailyPurchaseAmount}
                    onChange={(e) => setDailyPurchaseAmount(e.target.value)}
                    className="focus:ring-purple-500 focus:border-purple-500 block w-full pl-10 pr-12 sm:text-sm border-gray-300 rounded-md"
                    placeholder="0.00"
                  />
                </div>
              </div>

              <div className="sm:col-span-2">
                <label htmlFor="notes" className="block text-sm font-medium text-gray-700">
                  Observações
                </label>
                <textarea
                  id="notes"
                  rows={4}
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                  placeholder="Adicione observações sobre o fechamento..."
                />
              </div>
            </div>

            <div className="flex flex-col sm:flex-row gap-4">
              <button
                type="submit"
                disabled={saving}
                className="btn-primary flex-1"
              >
                {saving ? (
                  <>
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin mr-2"></div>
                    Salvando...
                  </>
                ) : (
                  <>
                    <Save className="h-5 w-5 mr-2" />
                    Salvar
                  </>
                )}
              </button>

              <button
                type="button"
                onClick={shareOnWhatsApp}
                className="btn-primary bg-green-600 hover:bg-green-700 focus:ring-green-500 flex-1"
              >
                <Share2 className="h-5 w-5 mr-2" />
                Compartilhar
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default CashClosing;