#!/bin/bash
# MEYPARK IA - Deploy to Supabase Cloud
# Script completo para desplegar todo a Supabase Cloud

set -e

echo "🚀 MEYPARK IA - Deploy to Supabase Cloud"
echo "========================================="

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
if [ ! -f ".env" ]; then
    print_error ".env file not found"
    exit 1
fi

source .env

# Check if required variables are set
if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    print_error "SUPABASE_SERVICE_ROLE_KEY not set in .env file"
    exit 1
fi

if [ -z "$NEXT_PUBLIC_SUPABASE_URL" ]; then
    print_error "NEXT_PUBLIC_SUPABASE_URL not set in .env file"
    exit 1
fi

print_status "Deploying to Supabase project: $SUPABASE_PROJECT_REF"

# Set environment variables for Supabase CLI
export SUPABASE_URL="$NEXT_PUBLIC_SUPABASE_URL"
export SUPABASE_SERVICE_ROLE_KEY="$SUPABASE_SERVICE_ROLE_KEY"

# Create packages directory structure
print_status "Creating package structure..."
mkdir -p packages/shared_core/src
mkdir -p packages/shared_core/lib

# Step 1: Apply database schema
print_status "Step 1/5: Applying database schema..."
supabase db push --db-url "$NEXT_PUBLIC_SUPABASE_URL" --password "$SUPABASE_SERVICE_ROLE_KEY"

# Step 2: Apply RLS policies
print_status "Step 2/5: Applying RLS policies..."
psql "$NEXT_PUBLIC_SUPABASE_URL" -f infra/rls_policies.sql

# Step 3: Apply views and realtime
print_status "Step 3/5: Applying views and realtime configuration..."
psql "$NEXT_PUBLIC_SUPABASE_URL" -f infra/views_realtime.sql

# Step 4: Deploy Edge Functions
print_status "Step 4/5: Deploying Edge Functions..."

# Deploy invoice-get function
supabase functions deploy invoice-get --project-ref $SUPABASE_PROJECT_REF

# Deploy commands function
supabase functions deploy commands --project-ref $SUPABASE_PROJECT_REF

# Deploy alerts function
supabase functions deploy alerts --project-ref $SUPABASE_PROJECT_REF

# Step 5: Generate types
print_status "Step 5/5: Generating types..."

# Generate TypeScript types
supabase gen types typescript --project-id $SUPABASE_PROJECT_REF > packages/shared_core/src/supabase.types.ts

# Generate Dart types
supabase gen types dart --project-id $SUPABASE_PROJECT_REF > packages/shared_core/lib/supabase_types.dart

print_success "Deployment completed successfully!"
echo ""
echo "🎉 MEYPARK IA Backend Ready!"
echo "=========================="
echo ""
echo "✅ Database schema with 25+ tables"
echo "✅ RLS policies and security configured"
echo "✅ Realtime subscriptions enabled"
echo "✅ Edge Functions deployed"
echo "✅ TypeScript and Dart types generated"
echo ""
echo "🔗 Your Supabase Dashboard:"
echo "https://supabase.com/dashboard/project/$SUPABASE_PROJECT_REF"
echo ""
echo "📋 Next Steps:"
echo "1. Check your Supabase dashboard"
echo "2. Start developing your applications"
echo "3. Use the generated types in your code"
echo "4. Test the Edge Functions"
echo ""
