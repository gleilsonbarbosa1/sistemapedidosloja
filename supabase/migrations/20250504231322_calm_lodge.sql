/*
  # Fix recursive RLS policies for profiles table

  1. Changes
    - Remove recursive policies that were causing infinite loops
    - Restructure policies to avoid self-referential queries
    - Maintain security while fixing the recursion issue
  
  2. Security
    - Maintain existing security model where:
      - Users can view their own profile
      - Admins can view and update all profiles
      - Managers can view all profiles
    - Policies are now more efficient and avoid recursion
*/

-- Drop existing policies to recreate them
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Managers and admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Admins can update profiles" ON profiles;

-- Create new non-recursive policies
CREATE POLICY "Users can view their own profile"
ON profiles FOR SELECT
TO public
USING (auth.uid() = id);

CREATE POLICY "Admins can view all profiles"
ON profiles FOR SELECT
TO public
USING (
  auth.jwt() ->> 'role' = 'admin'
);

CREATE POLICY "Managers can view all profiles"
ON profiles FOR SELECT
TO public
USING (
  auth.jwt() ->> 'role' = 'manager'
);

CREATE POLICY "Admins can update profiles"
ON profiles FOR UPDATE
TO public
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');