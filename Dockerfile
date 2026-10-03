# Build Stage
FROM node:alpine AS build
WORKDIR /app
RUN npm install -g pnpm@12.8.1
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .

# Development stage w/ dev dependencies

FROM build AS development
# RUN npm install --save-dev 
EXPOSE 3000
CMD ["pnpm", "start"]

# Production stage (no tag so it's the default)

FROM build AS production
RUN pnpm run build
EXPOSE 4000

CMD ["npx", "serve", "-s", "build", "-l", "4000"]
