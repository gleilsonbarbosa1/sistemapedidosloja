/*
  # Create Checklist Fechamento Table

  1. New Tables
    - checklist_fechamento - Daily closing checklist
      - id (uuid, primary key)
      - atendente_id (uuid, references auth.users)
      - data (date)
      - ar_desligado (boolean)
      - freezer_fechado (boolean)
      - lixo_retirado (boolean)
      - piso_limpo (boolean)
      - luzes_apagadas (boolean)
      - caixa_fechado (boolean)
      - portas_trancadas (boolean)
      - freezer_cozinha_limpo (boolean)
      - freezer_acai_limpo (boolean)
      - freezer_sorvetes_limpo (boolean)
      - freezer_sorvetes_preparado (boolean)
      - created_at (timestamptz)

  2. Security
    - Enable RLS
    - Add policies for authenticated users
*/

CREATE TABLE IF NOT EXISTS checklist_fechamento (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  atendente_id UUID NOT NULL REFERENCES auth.users(id),
  data DATE NOT NULL DEFAULT CURRENT_DATE,
  ar_desligado BOOLEAN NOT NULL DEFAULT false,
  freezer_fechado BOOLEAN NOT NULL DEFAULT false,
  lixo_retirado BOOLEAN NOT NULL DEFAULT false,
  piso_limpo BOOLEAN NOT NULL DEFAULT false,
  luzes_apagadas BOOLEAN NOT NULL DEFAULT false,
  caixa_fechado BOOLEAN NOT NULL DEFAULT false,
  portas_trancadas BOOLEAN NOT NULL DEFAULT false,
  freezer_cozinha_limpo BOOLEAN NOT NULL DEFAULT false,
  freezer_acai_limpo BOOLEAN NOT NULL DEFAULT false,
  freezer_sorvetes_limpo BOOLEAN NOT NULL DEFAULT false,
  freezer_sorvetes_preparado BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE checklist_fechamento ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for authenticated users"
  ON checklist_fechamento FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users"
  ON checklist_fechamento FOR INSERT
  TO authenticated
  WITH CHECK (true);