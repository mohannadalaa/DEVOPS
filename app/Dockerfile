# pull official base image
FROM ontellus.azurecr.io/node:18.17.0-alpine as build

# ARG SONAR_PROJECT_KEY=keaisdev_locations
# ARG SONAR_OGRANIZAION_KEY=ontellus
# ARG SONAR_HOST_URL=https://sonarcloud.io
# ARG SONAR_TOKEN
# ARG BRANCH_NAME
# ARG TARGET_BRANCH

# set unique working directory where our files will go to inside the container
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY ./package.json ./
# COPY ./package-lock.json ./
RUN npm install -g npm@9.8.1
RUN npm install --silent
RUN npm install react-scripts@5.0.1 -g

# add app
COPY ./ ./

RUN npm run build

# RUN npm run test -- --coverage --ci --watchAll=false

# Start Sonar Scanner (only on non master branches)
# RUN target_branch_parm="" && \
#     if [ "$BRANCH_NAME" != "$TARGET_BRANCH" ] ; then target_branch_parm=-Dsonar.newCode.referenceBranch="$TARGET_BRANCH" ; fi && \
#   sonar-scanner \
#   -Dsonar.organization="$SONAR_OGRANIZAION_KEY" \
#   -Dsonar.projectKey="$SONAR_PROJECT_KEY" \
#   -Dsonar.sources=./src/ \
#   -Dsonar.host.url="$SONAR_HOST_URL" \
#   -Dsonar.login="$SONAR_TOKEN" \
#   -Dsonar.javascript.lcov.reportPaths="./coverage/lcov.info" \
#   -Dsonar.branch.name="$BRANCH_NAME" \
#   -Dsonar.coverage.exclusions="**/*.test.tsx,**/*.test.ts,**/mocks/*,**/settings/*,**/context/*,**/assets/*,**/Models/*,**/setupTests.ts,**/reportWebVitals.ts,**/index.tsx" \
#   $target_branch_parm

# production environment
# FROM ontellus.azurecr.io/nginx:1.25.1-alpine

# COPY --from=build /app/build /usr/share/nginx/html

# COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

# RUN adduser --disabled-password \
#   --home /app \
#   --gecos '' appuser && chown -R appuser /app

# RUN chown -R appuser:appuser /usr/share/nginx/html && chmod -R 755 /usr/share/nginx/html && \
#   chown -R appuser:appuser /var/cache/nginx && \
#   chown -R appuser:appuser /var/log/nginx && \
#   chown -R appuser:appuser /etc/nginx/conf.d && \
#   chown -R appuser:appuser /var/run/

# RUN touch /var/run/nginx.pid && \
#   chown -R appuser:appuser /var/run/nginx.pid

# WORKDIR /usr/share/nginx/html
# COPY ./env.sh .
# COPY ./.env .

# RUN chmod +x /usr/share/nginx/html/env.sh && \
#   chown -R appuser:appuser /usr/share/nginx/html/env.sh

# USER appuser

EXPOSE 3000

# ENV scripts_path=/scripts

# CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]

CMD [ "npm", "start" ]