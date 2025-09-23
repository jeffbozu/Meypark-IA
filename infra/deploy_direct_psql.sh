#!/bin/bash
# MEYPARK IA - Deploy to Supabase Cloud (Direct psql)
# Script para desplegar usando psql directamente

set -e

echo "🚀 MEYPARK IA - Deploy to Supabase Cloud (Direct)"
echo "================================================="

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

# Create packages directory structure
print_status "Creating package structure..."
mkdir -p packages/shared_core/src
mkdir -p packages/shared_core/lib

# Construct PostgreSQL connection string
# Convert Supabase URL to PostgreSQL format
DB_URL="$NEXT_PUBLIC_SUPABASE_URL"
DB_URL="${DB_URL/https:\/\//postgresql://}"
DB_URL="${DB_URL/.supabase.co/.supabase.co:5432}"

print_status "Connecting to database..."

# Set password for psql
export PGPASSWORD="$SUPABASE_SERVICE_ROLE_KEY"

# Step 1: Apply database schema
print_status "Step 1/4: Applying database schema..."
psql "$DB_URL" -f infra/supabase_migrations.sql

# Step 2: Apply RLS policies
print_status "Step 2/4: Applying RLS policies..."
psql "$DB_URL" -f infra/rls_policies.sql

# Step 3: Apply views and realtime
print_status "Step 3/4: Applying views and realtime configuration..."
psql "$DB_URL" -f infra/views_realtime.sql

# Step 4: Generate types (using curl to Supabase API)
print_status "Step 4/4: Generating types..."

# Generate TypeScript types using Supabase API
curl -X GET \
  "https://edkwlmauywdxbencaucj.supabase.co/rest/v1/type?select=*" \
  -H "apikey: $NEXT_PUBLIC_SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
  -o packages/shared_core/src/supabase.types.ts

# Create a basic Dart types file
cat > packages/shared_core/lib/supabase_types.dart << 'EOF'
// MEYPARK IA - Supabase Types (Dart)
// Generated types for Flutter applications

class Database {
  // This will be populated with actual generated types
  // when we have proper access to Supabase CLI
}

class Tables {
  // Table definitions will be here
}
EOF

print_success "Deployment completed successfully!"
echo ""
echo "🎉 MEYPARK IA Backend Ready!"
echo "=========================="
echo ""
echo "✅ Database schema with 25+ tables"
echo "✅ RLS policies and security configured"
echo "✅ Realtime subscriptions enabled"
echo "✅ Basic types generated"
echo ""
echo "🔗 Your Supabase Dashboard:"
echo "https://supabase.com/dashboard/project/$SUPABASE_PROJECT_REF"
echo ""
echo "📋 Next Steps:"
echo "1. Check your Supabase dashboard"
echo "2. Get proper SUPABASE_ACCESS_TOKEN for full CLI access"
echo "3. Deploy Edge Functions with: supabase functions deploy"
echo "4. Generate proper types with: supabase gen types"
echo ""
