#!/usr/bin/env python3
"""
MEYPARK IA - Apply SQL to Supabase
Script para aplicar migraciones SQL a Supabase usando la API
"""

import requests
import json
import os
import sys
from urllib.parse import urljoin

def load_env():
    """Load environment variables from .env file"""
    env_vars = {}
    if os.path.exists('.env'):
        with open('.env', 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key] = value
    return env_vars

def execute_sql(sql_content, supabase_url, service_key):
    """Execute SQL using Supabase API"""
    url = urljoin(supabase_url, '/rest/v1/rpc/exec_sql')
    
    headers = {
        'apikey': service_key,
        'Authorization': f'Bearer {service_key}',
        'Content-Type': 'application/json'
    }
    
    data = {
        'sql': sql_content
    }
    
    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error executing SQL: {e}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"Response: {e.response.text}")
        return None

def main():
    print("🚀 MEYPARK IA - Apply SQL to Supabase")
    print("====================================")
    
    # Load environment variables
    env_vars = load_env()
    
    supabase_url = env_vars.get('NEXT_PUBLIC_SUPABASE_URL')
    service_key = env_vars.get('SUPABASE_SERVICE_ROLE_KEY')
    
    if not supabase_url or not service_key:
        print("❌ Error: Missing SUPABASE_URL or SERVICE_ROLE_KEY")
        sys.exit(1)
    
    print(f"📡 Connecting to: {supabase_url}")
    
    # Read and execute schema migration
    print("📋 Step 1/3: Applying database schema...")
    with open('infra/supabase_migrations.sql', 'r') as f:
        schema_sql = f.read()
    
    result = execute_sql(schema_sql, supabase_url, service_key)
    if result is not None:
        print("✅ Database schema applied successfully")
    else:
        print("❌ Failed to apply database schema")
        return
    
    # Read and execute RLS policies
    print("📋 Step 2/3: Applying RLS policies...")
    with open('infra/rls_policies.sql', 'r') as f:
        rls_sql = f.read()
    
    result = execute_sql(rls_sql, supabase_url, service_key)
    if result is not None:
        print("✅ RLS policies applied successfully")
    else:
        print("❌ Failed to apply RLS policies")
        return
    
    # Read and execute views and realtime
    print("📋 Step 3/3: Applying views and realtime...")
    with open('infra/views_realtime.sql', 'r') as f:
        views_sql = f.read()
    
    result = execute_sql(views_sql, supabase_url, service_key)
    if result is not None:
        print("✅ Views and realtime applied successfully")
    else:
        print("❌ Failed to apply views and realtime")
        return
    
    print("\n🎉 MEYPARK IA Backend Ready!")
    print("==========================")
    print("✅ Database schema with 25+ tables")
    print("✅ RLS policies and security configured")
    print("✅ Realtime subscriptions enabled")
    print(f"\n🔗 Your Supabase Dashboard:")
    print(f"https://supabase.com/dashboard/project/{env_vars.get('SUPABASE_PROJECT_REF')}")

if __name__ == "__main__":
    main()
