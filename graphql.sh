#!/bin/bash

# Step 1: Project directory creation
echo "Enter your project name: "
read project_name
mkdir $project_name
cd $project_name

# Step 2: Initialize Node.js project
echo "Initializing Node.js project..."
npm init -y

# Step 3: Install necessary dependencies
echo "Installing Express, Apollo Server, GraphQL and other dependencies..."
npm install express apollo-server-express graphql

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
touch src/index.ts src/schema.ts src/resolvers.ts

# Step 7: Add basic Express and Apollo Server code to index.ts
cat <<EOT >> src/index.ts
import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import { typeDefs } from './schema';
import { resolvers } from './resolvers';

const app = express();
const port = process.env.PORT || 4000;

const server = new ApolloServer({ typeDefs, resolvers });

server.start().then(() => {
  server.applyMiddleware({ app });

  app.listen(port, () => {
    console.log(\`Server running at http://localhost:\${port}\${server.graphqlPath}\`);
  });
});
EOT

# Step 8: Add basic GraphQL schema to schema.ts
cat <<EOT >> src/schema.ts
import { gql } from 'apollo-server-express';

export const typeDefs = gql\`
  type Query {
    hello: String
  }
\`;
EOT

# Step 9: Add basic resolvers to resolvers.ts
cat <<EOT >> src/resolvers.ts
export const resolvers = {
  Query: {
    hello: () => 'Hello, GraphQL!',
  },
};
EOT

# Step 10: Set up a basic nodemon configuration for development
echo "Setting up Nodemon configuration..."
cat <<EOT >> nodemon.json
{
  "watch": ["src"],
  "ext": ".ts",
  "ignore": ["dist"],
  "exec": "ts-node ./src/index.ts"
}
EOT

# Step 11: Update package.json scripts
echo "Updating package.json scripts..."
npx json -I -f package.json -e 'this.scripts.start="node dist/index.js"'
npx json -I -f package.json -e 'this.scripts.dev="nodemon"'

# Step 12: Final message
echo "Node.js GraphQL API boilerplate with TypeScript is ready!"
echo "Run 'npm run dev' to start the development server."
