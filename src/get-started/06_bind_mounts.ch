%This is the change file for the original Docker's Documentation file.
%This is part of Japanese translation version for Docker's Documantation.

@x
---
title: "Using bind mounts"
keywords: get started, setup, orientation, quickstart, intro, concepts, containers, docker desktop
description: Using bind mounts in our application
---
@y
---
title: "Using bind mounts"
keywords: get started, setup, orientation, quickstart, intro, concepts, containers, docker desktop
description: Using bind mounts in our application
---
@z

@x
In the previous chapter, we talked about and used a **named volume** to persist the data in our database.
Named volumes are great if we simply want to store data, as we don't have to worry about _where_ the data
is stored.
@y
In the previous chapter, we talked about and used a **named volume** to persist the data in our database.
Named volumes are great if we simply want to store data, as we don't have to worry about _where_ the data
is stored.
@z

@x
With **bind mounts**, we control the exact mountpoint on the host. We can use this to persist data, but is often
used to provide additional data into containers. When working on an application, we can use a bind mount to
mount our source code into the container to let it see code changes, respond, and let us see the changes right
away.
@y
With **bind mounts**, we control the exact mountpoint on the host. We can use this to persist data, but is often
used to provide additional data into containers. When working on an application, we can use a bind mount to
mount our source code into the container to let it see code changes, respond, and let us see the changes right
away.
@z

@x
For Node-based applications, [nodemon](https://npmjs.com/package/nodemon) is a great tool to watch for file
changes and then restart the application. There are equivalent tools in most other languages and frameworks.
@y
For Node-based applications, [nodemon](https://npmjs.com/package/nodemon) is a great tool to watch for file
changes and then restart the application. There are equivalent tools in most other languages and frameworks.
@z

@x
## Quick Volume Type Comparisons
@y
## Quick Volume Type Comparisons
@z

@x
Bind mounts and named volumes are the two main types of volumes that come with the Docker engine. However, additional
volume drivers are available to support other uses cases ([SFTP](https://github.com/vieux/docker-volume-sshfs), [Ceph](https://ceph.com/geen-categorie/getting-started-with-the-docker-rbd-volume-plugin/), [NetApp](https://netappdvp.readthedocs.io/en/stable/), [S3](https://github.com/elementar/docker-s3-volume), and more).
@y
Bind mounts and named volumes are the two main types of volumes that come with the Docker engine. However, additional
volume drivers are available to support other uses cases ([SFTP](https://github.com/vieux/docker-volume-sshfs), [Ceph](https://ceph.com/geen-categorie/getting-started-with-the-docker-rbd-volume-plugin/), [NetApp](https://netappdvp.readthedocs.io/en/stable/), [S3](https://github.com/elementar/docker-s3-volume), and more).
@z

@x
|   | Named Volumes | Bind Mounts |
| - | ------------- | ----------- |
| Host Location | Docker chooses | You control |
| Mount Example (using `-v`) | my-volume:/usr/local/data | /path/to/data:/usr/local/data |
| Populates new volume with container contents | Yes | No |
| Supports Volume Drivers | Yes | No |
@y
|   | Named Volumes | Bind Mounts |
| - | ------------- | ----------- |
| Host Location | Docker chooses | You control |
| Mount Example (using `-v`) | my-volume:/usr/local/data | /path/to/data:/usr/local/data |
| Populates new volume with container contents | Yes | No |
| Supports Volume Drivers | Yes | No |
@z

@x
## Starting a Dev-Mode Container
@y
## Starting a Dev-Mode Container
@z

@x
To run our container to support a development workflow, we will do the following:
@y
To run our container to support a development workflow, we will do the following:
@z

@x
- Mount our source code into the container
- Install all dependencies, including the "dev" dependencies
- Start nodemon to watch for filesystem changes
@y
- Mount our source code into the container
- Install all dependencies, including the "dev" dependencies
- Start nodemon to watch for filesystem changes
@z

@x
So, let's do it!
@y
So, let's do it!
@z

@x
1. Make sure you don't have any previous `getting-started` containers running.
@y
1. Make sure you don't have any previous `getting-started` containers running.
@z

@x
1. Run the following command. We'll explain what's going on afterwards:
@y
1. Run the following command. We'll explain what's going on afterwards:
@z

@x
    ```bash
    docker run -dp 3000:3000 \
        -w /app -v "$(pwd):/app" \
        node:12-alpine \
        sh -c "yarn install && yarn run dev"
    ```
@y
    ```bash
    docker run -dp 3000:3000 \
        -w /app -v "$(pwd):/app" \
        node:12-alpine \
        sh -c "yarn install && yarn run dev"
    ```
@z

@x
    If you are using PowerShell then use this command.
@y
    If you are using PowerShell then use this command.
@z

@x
    ```powershell
    docker run -dp 3000:3000 `
        -w /app -v "$(pwd):/app" `
        node:12-alpine `
        sh -c "yarn install && yarn run dev"
    ```
@y
    ```powershell
    docker run -dp 3000:3000 `
        -w /app -v "$(pwd):/app" `
        node:12-alpine `
        sh -c "yarn install && yarn run dev"
    ```
@z

@x
    - `-dp 3000:3000` - same as before. Run in detached (background) mode and create a port mapping
    - `-w /app` - sets the "working directory" or the current directory that the command will run from
    - `-v "$(pwd):/app"` - bind mount the current directory from the host in the container into the `/app` directory
    - `node:12-alpine` - the image to use. Note that this is the base image for our app from the Dockerfile
    - `sh -c "yarn install && yarn run dev"` - the command. We're starting a shell using `sh` (alpine doesn't have `bash`) and
      running `yarn install` to install _all_ dependencies and then running `yarn run dev`. If we look in the `package.json`,
      we'll see that the `dev` script is starting `nodemon`.
@y
    - `-dp 3000:3000` - same as before. Run in detached (background) mode and create a port mapping
    - `-w /app` - sets the "working directory" or the current directory that the command will run from
    - `-v "$(pwd):/app"` - bind mount the current directory from the host in the container into the `/app` directory
    - `node:12-alpine` - the image to use. Note that this is the base image for our app from the Dockerfile
    - `sh -c "yarn install && yarn run dev"` - the command. We're starting a shell using `sh` (alpine doesn't have `bash`) and
      running `yarn install` to install _all_ dependencies and then running `yarn run dev`. If we look in the `package.json`,
      we'll see that the `dev` script is starting `nodemon`.
@z

@x
1. You can watch the logs using `docker logs -f <container-id>`. You'll know you're ready to go when you see this...
@y
1. You can watch the logs using `docker logs -f <container-id>`. You'll know you're ready to go when you see this...
@z

@x
    ```bash
    docker logs -f <container-id>
    $ nodemon src/index.js
    [nodemon] 1.19.2
    [nodemon] to restart at any time, enter `rs`
    [nodemon] watching dir(s): *.*
    [nodemon] starting `node src/index.js`
    Using sqlite database at /etc/todos/todo.db
    Listening on port 3000
    ```
@y
    ```bash
    docker logs -f <container-id>
    $ nodemon src/index.js
    [nodemon] 1.19.2
    [nodemon] to restart at any time, enter `rs`
    [nodemon] watching dir(s): *.*
    [nodemon] starting `node src/index.js`
    Using sqlite database at /etc/todos/todo.db
    Listening on port 3000
    ```
@z

@x
    When you're done watching the logs, exit out by hitting `Ctrl`+`C`.
@y
    When you're done watching the logs, exit out by hitting `Ctrl`+`C`.
@z

@x
1. Now, let's make a change to the app. In the `src/static/js/app.js` file, let's change the "Add Item" button to simply say
   "Add". This change will be on line 109.
@y
1. Now, let's make a change to the app. In the `src/static/js/app.js` file, let's change the "Add Item" button to simply say
   "Add". This change will be on line 109.
@z

@x
    ```diff
    -                         {submitting ? 'Adding...' : 'Add Item'}
    +                         {submitting ? 'Adding...' : 'Add'}
    ```
@y
    ```diff
    -                         {submitting ? 'Adding...' : 'Add Item'}
    +                         {submitting ? 'Adding...' : 'Add'}
    ```
@z

@x
1. Simply refresh the page (or open it) and you should see the change reflected in the browser almost immediately. It might
   take a few seconds for the Node server to restart, so if you get an error, just try refreshing after a few seconds.
@y
1. Simply refresh the page (or open it) and you should see the change reflected in the browser almost immediately. It might
   take a few seconds for the Node server to restart, so if you get an error, just try refreshing after a few seconds.
@z

@x
    ![Screenshot of updated label for Add button](images/updated-add-button.png){: style="width:75%;"}
    {: .text-center }
@y
    ![Screenshot of updated label for Add button](images/updated-add-button.png){: style="width:75%;"}
    {: .text-center }
@z

@x
1. Feel free to make any other changes you'd like to make. When you're done, stop the container and build your new image
   using `docker build -t getting-started .`.
@y
1. Feel free to make any other changes you'd like to make. When you're done, stop the container and build your new image
   using `docker build -t getting-started .`.
@z

@x
Using bind mounts is _very_ common for local development setups. The advantage is that the dev machine doesn't need to have
all of the build tools and environments installed. With a single `docker run` command, the dev environment is pulled and ready
to go. We'll talk about Docker Compose in a future step, as this will help simplify our commands (we're already getting a lot
of flags).
@y
Using bind mounts is _very_ common for local development setups. The advantage is that the dev machine doesn't need to have
all of the build tools and environments installed. With a single `docker run` command, the dev environment is pulled and ready
to go. We'll talk about Docker Compose in a future step, as this will help simplify our commands (we're already getting a lot
of flags).
@z

@x
## Recap
@y
## Recap
@z

@x
At this point, we can persist our database and respond rapidly to the needs and demands of our investors and founders. Hooray!
But, guess what? We received great news!
@y
At this point, we can persist our database and respond rapidly to the needs and demands of our investors and founders. Hooray!
But, guess what? We received great news!
@z

@x
**Your project has been selected for future development!** 
@y
**Your project has been selected for future development!** 
@z

@x
In order to prepare for production, we need to migrate our database from working in SQLite to something that can scale a
little better. For simplicity, we'll keep with a relational database and switch our application to use MySQL. But, how 
should we run MySQL? How do we allow the containers to talk to each other? We'll talk about that next!
@y
In order to prepare for production, we need to migrate our database from working in SQLite to something that can scale a
little better. For simplicity, we'll keep with a relational database and switch our application to use MySQL. But, how 
should we run MySQL? How do we allow the containers to talk to each other? We'll talk about that next!
@z
