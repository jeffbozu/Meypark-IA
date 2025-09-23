#!/bin/bash
# MEYPARK IA - Setup Supabase Cloud (Direct Connection)
# Script para configurar el backend en Supabase Cloud usando service role

set -e

echo "🚀 MEYPARK IA - Setup Supabase Cloud (Direct)"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Load environment variables
if [ -f ".env" ]; then
    source .env
else
    print_error ".env file not found"
    exit 1
fi

# Check if required variables are set
if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    print_error "SUPABASE_SERVICE_ROLE_KEY not set in .env file"
    exit 1
fi

if [ -z "$NEXT_PUBLIC_SUPABASE_URL" ]; then
    print_error "NEXT_PUBLIC_SUPABASE_URL not set in .env file"
    exit 1
fi

print_status "Setting up Supabase project: $SUPABASE_PROJECT_REF"
print_status "Using direct connection with service role key"

# Create packages directory structure
mkdir -p packages/shared_core/src
mkdir -p packages/shared_core/lib

# Apply migrations directly using psql
print_status "Applying database migrations..."

# Extract database URL from service role key
DB_URL="$NEXT_PUBLIC_SUPABASE_URL"
DB_URL="${DB_URL/https:\/\//postgresql://}"
DB_URL="${DB_URL/.supabase.co/.supabase.co:5432}"

# Use service role key for authentication
export PGPASSWORD="$SUPABASE_SERVICE_ROLE_KEY"

# Apply the migration
psql "$DB_URL" -f infra/supabase_migrations.sql

print_success "Database migrations applied successfully!"

# Generate types using Supabase CLI with service role
print_status "Generating TypeScript types..."
supabase gen types typescript --project-id $SUPABASE_PROJECT_REF --schema public > packages/shared_core/src/supabase.types.ts

print_status "Generating Dart types..."
supabase gen types dart --project-id $SUPABASE_PROJECT_REF --schema public > packages/shared_core/lib/supabase_types.dart

print_success "Types generated successfully!"

print_success "Supabase setup completed successfully!"
echo ""
echo "🎉 MEYPARK IA Backend Ready!"
echo "=========================="
echo ""
echo "Your Supabase project is now configured with:"
echo "✅ Database schema with 25+ tables"
echo "✅ RLS policies and security"
echo "✅ TypeScript and Dart types generated"
echo ""
echo "Next steps:"
echo "1. Check your Supabase dashboard: https://supabase.com/dashboard/project/$SUPABASE_PROJECT_REF"
echo "2. Start developing your applications"
echo "3. Use the generated types in your code"
echo ""
