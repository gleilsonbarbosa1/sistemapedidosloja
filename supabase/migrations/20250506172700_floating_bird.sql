/*
  # Remove Unused Tables

  1. Changes
    - Safely check for table existence before dropping
    - Remove cash_closings table if it exists
    - Clean up any associated policies
*/

DO $$ 
BEGIN
  -- Only attempt to drop policies if the table exists
  IF EXISTS (
    SELECT 1 
    FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'cash_closings'
  ) THEN
    DROP POLICY IF EXISTS "Enable read access for authenticated users" ON cash_closings;
    DROP POLICY IF EXISTS "Enable insert for authenticated users" ON cash_closings;
    DROP TABLE IF EXISTS cash_closings CASCADE;
  END IF;
END $$;