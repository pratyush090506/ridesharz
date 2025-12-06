#!/bin/bash

echo "🚀 RideSharz - Quick Deployment Setup"
echo "====================================="
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "📁 Initializing Git repository..."
    git init
    echo "✓ Git initialized"
else
    echo "✓ Git already initialized"
fi

# Create/update .gitignore
echo "📝 Setting up .gitignore..."
cat > .gitignore << 'EOF'
target/
app.log
*.log
frontend/node_modules/
frontend/dist/
.DS_Store
*.jar.original
.env
.vscode/
.idea/
*.iml
EOF
echo "✓ .gitignore created"

# Clean build artifacts
echo "🧹 Cleaning build artifacts..."
mvn clean > /dev/null 2>&1
rm -rf frontend/node_modules frontend/dist app.log
echo "✓ Cleaned"

# Create frontend .env.example
echo "📄 Creating environment variable templates..."
cat > frontend/.env.example << 'EOF'
VITE_API_URL=http://localhost:8081
EOF
echo "✓ Created frontend/.env.example"

# Git add and commit
echo "💾 Committing to Git..."
git add .
git commit -m "Initial commit: RideSharz full-stack application" > /dev/null 2>&1
echo "✓ Committed to Git"

echo ""
echo "✅ Setup Complete!"
echo ""
echo "Next Steps:"
echo "1. Create a repository on GitHub"
echo "2. Run: git remote add origin https://github.com/YOUR_USERNAME/ridesharz.git"
echo "3. Run: git push -u origin main"
echo ""
echo "Then deploy:"
echo "- Backend: railway.app (connect GitHub repo)"
echo "- Frontend: vercel.com (connect GitHub repo, root: frontend)"
echo ""
echo "See DEPLOYMENT_RAILWAY.md for detailed instructions."
