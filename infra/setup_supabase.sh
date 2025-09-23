#!/bin/bash
# MEYPARK IA - Setup Supabase Cloud
# Script para configurar el backend en Supabase Cloud

set -e

echo "🚀 MEYPARK IA - Setup Supabase Cloud"
echo "===================================="

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

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_error ".env file not found. Please create it with your Supabase credentials:"
    print_error "NEXT_PUBLIC_SUPABASE_URL=https://edkwlmauywdxbencaucj.supabase.co"
    print_error "NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here"
    print_error "SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here"
    print_error "SUPABASE_ACCESS_TOKEN=your_access_token_here"
    exit 1
fi

# Load environment variables
source .env

# Check if required variables are set
if [ -z "$SUPABASE_ACCESS_TOKEN" ]; then
    print_error "SUPABASE_ACCESS_TOKEN not set in .env file"
    exit 1
fi

if [ -z "$SUPABASE_PROJECT_REF" ]; then
    print_error "SUPABASE_PROJECT_REF not set in .env file"
    exit 1
fi

print_status "Setting up Supabase project: $SUPABASE_PROJECT_REF"

# Set access token
export SUPABASE_ACCESS_TOKEN=$SUPABASE_ACCESS_TOKEN

# Link to project
print_status "Linking to Supabase project..."
supabase link --project-ref $SUPABASE_PROJECT_REF

# Apply migrations
print_status "Applying database migrations..."
supabase db push

# Generate types
print_status "Generating TypeScript types..."
supabase gen types typescript --project-id $SUPABASE_PROJECT_REF > packages/shared_core/src/supabase.types.ts

print_status "Generating Dart types..."
supabase gen types dart --project-id $SUPABASE_PROJECT_REF > packages/shared_core/lib/supabase_types.dart

# Deploy Edge Functions
print_status "Deploying Edge Functions..."
supabase functions deploy invoice-get
supabase functions deploy commands
supabase functions deploy alerts

print_success "Supabase setup completed successfully!"
echo ""
echo "🎉 MEYPARK IA Backend Ready!"
echo "=========================="
echo ""
echo "Your Supabase project is now configured with:"
echo "✅ Database schema with 25+ tables"
echo "✅ RLS policies and security"
echo "✅ Edge Functions deployed"
echo "✅ TypeScript and Dart types generated"
echo ""
echo "Next steps:"
echo "1. Check your Supabase dashboard: https://supabase.com/dashboard/project/$SUPABASE_PROJECT_REF"
echo "2. Start developing your applications"
echo "3. Use the generated types in your code"
echo ""
