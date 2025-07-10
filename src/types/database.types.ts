export interface Database {
  public: {
    Tables: {
      stores: {
        Row: {
          id: string;
          name: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          created_at?: string;
        };
      };
      categories: {
        Row: {
          id: string;
          name: string;
          order_index: number;
          created_at: string;
        };
        Insert: {
          id: string;
          name: string;
          order_index: number;
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          order_index?: number;
          created_at?: string;
        };
      };
      products: {
        Row: {
          id: string;
          name: string;
          category_id: string;
          created_at: string;
          updated_at: string | null;
        };
        Insert: {
          id?: string;
          name: string;
          category_id: string;
          created_at?: string;
          updated_at?: string | null;
        };
        Update: {
          id?: string;
          name?: string;
          category_id?: string;
          created_at?: string;
          updated_at?: string | null;
        };
      };
      orders: {
        Row: {
          id: string;
          store_id: string;
          status: 'draft' | 'pending' | 'completed';
          created_by: string;
          created_at: string;
          updated_at: string | null;
          notes: string | null;
        };
        Insert: {
          id?: string;
          store_id: string;
          status?: 'draft' | 'pending' | 'completed';
          created_by: string;
          created_at?: string;
          updated_at?: string | null;
          notes?: string | null;
        };
        Update: {
          id?: string;
          store_id?: string;
          status?: 'draft' | 'pending' | 'completed';
          created_by?: string;
          created_at?: string;
          updated_at?: string | null;
          notes?: string | null;
        };
      };
      order_items: {
        Row: {
          id: string;
          order_id: string;
          product_id: string;
          quantity: number;
          status: 'full' | 'half' | 'empty';
          has_stock: boolean;
          notes: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          order_id: string;
          product_id: string;
          quantity: number;
          status?: 'full' | 'half' | 'empty';
          has_stock?: boolean;
          notes?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          order_id?: string;
          product_id?: string;
          quantity?: number;
          status?: 'full' | 'half' | 'empty';
          has_stock?: boolean;
          notes?: string | null;
          created_at?: string;
        };
      };
      cash_closings: {
        Row: {
          id: string;
          store_id: string;
          total_amount: number;
          date: string;
          created_by: string;
          created_at: string;
          notes: string | null;
        };
        Insert: {
          id?: string;
          store_id: string;
          total_amount: number;
          date: string;
          created_by: string;
          created_at?: string;
          notes?: string | null;
        };
        Update: {
          id?: string;
          store_id?: string;
          total_amount?: number;
          date?: string;
          created_by?: string;
          created_at?: string;
          notes?: string | null;
        };
      };
    };
  };
}