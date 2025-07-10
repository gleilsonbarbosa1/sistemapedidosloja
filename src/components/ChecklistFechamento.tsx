import React, { useState } from 'react';
import supabase from '../lib/supabase';
import toast from 'react-hot-toast';
import { Save } from 'lucide-react';

interface ChecklistFechamentoProps {
  atendenteId: string;
  value?: ChecklistState;
  onChange?: (checklist: ChecklistState) => void;
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

const ChecklistFechamento: React.FC<ChecklistFechamentoProps> = ({ 
  atendenteId, 
  value,
  onChange 
}) => {
  const [checklist, setChecklist] = useState<ChecklistState>(value || {
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

  const [saving, setSaving] = useState(false);

  const handleChange = (field: keyof ChecklistState) => {
    const newChecklist = {
      ...checklist,
      [field]: !checklist[field]
    };
    setChecklist(newChecklist);
    onChange?.(newChecklist);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);

    try {
      const { error } = await supabase
        .from('checklist_fechamento')
        .insert([
          {
            atendente_id: atendenteId,
            ...checklist
          }
        ]);

      if (error) throw error;

      toast.success('Checklist salvo com sucesso!');
      
      // Reset form
      const newChecklist = {
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
      };
      setChecklist(newChecklist);
      onChange?.(newChecklist);
    } catch (error) {
      console.error('Erro ao salvar checklist:', error);
      toast.error('Erro ao salvar checklist');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow p-4 sm:p-6">
      <h2 className="text-xl sm:text-2xl font-bold mb-4 sm:mb-6">Checklist de Fechamento</h2>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div className="space-y-3">
            <h3 className="font-semibold text-lg mb-2">Verificações Gerais</h3>
            
            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.ar_desligado}
                onChange={() => handleChange('ar_desligado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Ar-condicionado desligado</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.freezer_fechado}
                onChange={() => handleChange('freezer_fechado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Freezers bem fechados</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.lixo_retirado}
                onChange={() => handleChange('lixo_retirado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Lixo retirado</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.piso_limpo}
                onChange={() => handleChange('piso_limpo')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Piso limpo</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.luzes_apagadas}
                onChange={() => handleChange('luzes_apagadas')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Luzes apagadas</span>
            </label>
          </div>

          <div className="space-y-3">
            <h3 className="font-semibold text-lg mb-2">Limpeza e Organização</h3>
            
            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.freezer_cozinha_limpo}
                onChange={() => handleChange('freezer_cozinha_limpo')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Freezer cozinha limpo</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.freezer_acai_limpo}
                onChange={() => handleChange('freezer_acai_limpo')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Freezer açaí limpo</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.freezer_sorvetes_limpo}
                onChange={() => handleChange('freezer_sorvetes_limpo')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Freezer sorvetes limpo</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.freezer_sorvetes_preparado}
                onChange={() => handleChange('freezer_sorvetes_preparado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Freezer sorvetes preparado</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.banheiro_limpo}
                onChange={() => handleChange('banheiro_limpo')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Banheiro limpo</span>
            </label>
          </div>

          <div className="space-y-3">
            <h3 className="font-semibold text-lg mb-2">Verificações Finais</h3>
            
            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.caixa_fechado}
                onChange={() => handleChange('caixa_fechado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Caixa fechado</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.portas_trancadas}
                onChange={() => handleChange('portas_trancadas')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Portas trancadas</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.carregador_desligado}
                onChange={() => handleChange('carregador_desligado')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Carregador desligado</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.loucas_guardadas}
                onChange={() => handleChange('loucas_guardadas')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">Louças guardadas</span>
            </label>

            <label className="flex items-center space-x-3">
              <input
                type="checkbox"
                checked={checklist.tv_desligada}
                onChange={() => handleChange('tv_desligada')}
                className="form-checkbox h-5 w-5 text-purple-600"
              />
              <span className="text-sm sm:text-base">TV desligada</span>
            </label>
          </div>
        </div>

        <div className="mt-6">
          <button
            type="submit"
            disabled={saving}
            className="w-full flex justify-center items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-purple-600 hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 disabled:bg-purple-400 disabled:cursor-not-allowed"
          >
            {saving ? (
              <>
                <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Salvando...
              </>
            ) : (
              <>
                <Save className="h-5 w-5 mr-2" />
                Salvar Checklist
              </>
            )}
          </button>
        </div>
      </form>
    </div>
  );
};

export default ChecklistFechamento;