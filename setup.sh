#!/bin/bash

echo "🚀 RideShare Backend - Quick Setup"
echo "==================================="
echo ""

# Make test script executable
chmod +x test-workflow.sh
echo "✅ Made test-workflow.sh executable"
echo ""

echo "📋 Next Steps:"
echo ""
echo "1. Ensure MongoDB is running:"
echo "   brew services start mongodb-community"
echo ""
echo "2. Build and run the application:"
echo "   mvn spring-boot:run"
echo "   (or ./mvnw spring-boot:run)"
echo ""
echo "3. In another terminal, test the API:"
echo "   ./test-workflow.sh"
echo ""
echo "4. Or import postman-collection.json into Postman"
echo ""
echo "📚 Documentation:"
echo "   - README.md - Complete project documentation"
echo "   - STUDENT_HELPER.md - Student reference guide"
echo ""
echo "🎯 Application will run on: http://localhost:8081"
echo ""
