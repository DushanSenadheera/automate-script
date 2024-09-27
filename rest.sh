#!/bin/bash

# Step 1: Project directory creation
echo "Enter your project name: "
read project_name
mkdir $project_name
cd $project_name

# Step 2: Initialize Node.js project
echo "Initializing Node.js project..."
npm init -y

# Step 3: Install required dependencies
echo "Installing Express and other dependencies..."
npm install express
npm install cors
npm install dotenv
npm install body-parser

echo "Installing TypeScript and necessary dev dependencies..."
npm install --save-dev typescript ts-node @types/node @types/express nodemon

# Step 4: Initialize TypeScript configuration
echo "Initializing TypeScript configuration..."
npx tsc --init

# Step 5: Modify tsconfig.json (optional, for Node.js module resolution)
sed -i 's/"target": "es5"/"target": "es6"/' tsconfig.json
sed -i 's/"module": "commonjs"/"module": "ESNext"/' tsconfig.json
sed -i 's|// "outDir": "./"|  "outDir": "./dist"|' tsconfig.json
sed -i 's|// "rootDir": "./"|  "rootDir": "./src"|' tsconfig.json

# Step 6: Create folder structure and files
echo "Creating folder structure..."
mkdir src
touch src/index.ts

# Step 7: Add basic Express code to index.ts
cat <<EOT >> src/index.ts
import express, { Request, Response } from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());

app.get('/', (req: Request, res: Response) => {
  res.send('Hello, World!');
});

app.listen(port, () => {
  console.log(\`Server is running on port \${port}\`);
});
EOT

# Step 8: Set up a basic nodemon configuration for development
echo "Setting up Nodemon configuration..."
cat <<EOT >> nodemon.json
{
  "watch": ["src"],
  "ext": ".ts",
  "ignore": ["dist"],
  "exec": "ts-node ./src/index.ts"
}
EOT

# Step 9: Update package.json scripts
echo "Updating package.json scripts..."
npx json -I -f package.json -e 'this.scripts.start="node dist/index.js"'
npx json -I -f package.json -e 'this.scripts.dev="nodemon"'
npx json -I -f package.json -e 'this.type="module"'

# Step 10: Final message
echo "Node.js Express API boilerplate with TypeScript is ready!"
echo "Run 'npm run dev' to start the development server."
