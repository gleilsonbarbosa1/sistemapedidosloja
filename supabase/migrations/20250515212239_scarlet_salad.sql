/*
  # Update Checklist Schema

  1. Changes
    - Add new checklist fields
    - Add observations field
*/

-- Add new columns to checklist_fechamento
ALTER TABLE checklist_fechamento 
ADD COLUMN IF NOT EXISTS carregador_desligado BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN IF NOT EXISTS banheiro_limpo BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN IF NOT EXISTS loucas_guardadas BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN IF NOT EXISTS tv_desligada BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN IF NOT EXISTS observacoes TEXT;