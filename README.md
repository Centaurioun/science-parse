# Science Parse

## Fork version differences

This fork adds the Dockerfile back to the project which [version 2.0.3 had](https://github.com/allenai/science-parse/tree/v2.0.3). In comparison to that docker file this project also includes a build docker file which compiles the code and exports it to the docker file that is used as the science parse server. Additionally this version does not run as root user, it runs as a non-privileged user.

1. [./build.Dockerfile](./build.Dockerfile) -- Docker file that compiles the code and creates the `jar` that is used in the server. [./build.Dockerfile.dockerignore](build.Dockerfile.dockerignore) is the docker ignore file for this Docker file.
2. [Dockerfile](./Dockerfile) -- Docker file that will run the Science Parse server, this Dockerfile takes the `jar` that is compiled from the [./build.Dockerfile](./build.Dockerfile) build process. [./.dockerignore](./.dockerignore) docker ignore file for this Dockerfile.
3. [makeDocker.sh](./makeDocker.sh) -- shell script that builds the two docker files. To run this `./makeDocker.sh` it sets the following build arguments for the two docker files:
  1. `OPENJDK_TAG=8u282` -- uses Open JDK version 8u282
  2. `JAVA_MEMORY=8` -- when running the Science Parse server it will use 8GB of memory through the `java -Xmx` flag.

The docker files were built with [docker BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/).

To run the Dockerfile on 127.0.0.1:8080: `docker run -p 127.0.0.1:8080:8080 --rm --init ucrel/ucrel-science-parse:3.0.1`.

**Note** use the `--init` flag when running, [helps remove processes when exiting the container.](https://docs.docker.com/config/containers/multi-service_container/)

**Note** by default it will run the science parse java server with 8GB of RAM to specify the amount of RAM the server should use change the environment variable `JAVA_MEMORY` in the following command, in this example we have changed it to use 5GB of RAM and limit the amount of RAM the docker image can have to 6GB through the docker flags `--memory` and `--memory-swap`:

``` bash
docker run -p 127.0.0.1:8080:8080 --rm --init --memory=6g --memory-swap=6g --env JAVA_MEMORY=5 ucrel/ucrel-science-parse:3.0.1
```

### DockerFile on Docker hub

Instead of building the docker image from the repository you can get it from [UCREL's docker hub](https://hub.docker.com/r/ucrel/ucrel-science-parse):

``` bash
docker run -p 127.0.0.1:8080:8080 --rm --init ucrel/ucrel-science-parse:3.0.1
```

This will automatically pull `ucrel/ucrel-science-parse:3.0.1` docker image from docker hub and run it on host `127.0.0.1` at port `8080`.

You can get previous version of science parse e.g. [version 2.0.3 from AllenAI docker hub.](https://hub.docker.com/r/allenai/scienceparse)

## Original Introduction

Science Parse parses scientific papers (in PDF form) and returns them in structured form. As of today, it supports these fields:
 * Title
 * Authors
 * Abstract
 * Sections (each with heading and body text)
 * Bibliography, each with
   * Title
   * Authors
   * Venue
   * Year
 * Mentions, i.e., places in the paper where bibliography entries are mentioned

In JSON format, the [output looks like this](http://scienceparse.allenai.org/v1/498bb0efad6ec15dd09d941fb309aa18d6df9f5f) (or like [this, if you want sections](http://scienceparse.allenai.org/v1/498bb0efad6ec15dd09d941fb309aa18d6df9f5f?skipFields=sections)). The easiest way to get started is to use the output from this server.

## New version: SPv2

There is a new version of science-parse out that works in a completely different way. It has fewer
features, but higher quality in the output. Check out the details at https://github.com/allenai/spv2.

## Get started

There are three different ways to get started with SP. Each has its own document:

 * [Server](server/README.md): This contains the SP server. It's useful for PDF parsing as a service. It's also probably the easiest way to get going.
 * [CLI](cli/README.md): This contains the command line interface to SP. That's most useful for batch processing.
 * [Core](core/README.md): This contains SP as a library. It has all the extraction code, plus training and evaluation. Both server and CLI use this to do the actual work.

## How to include into your own project
 
The current version is `3.0.1`. If you want to include it in your own project, use this:

For SBT:
```
libraryDependencies += "org.allenai" %% "science-parse" % "3.0.1"
```

For Maven:
```
<dependency>
  <groupId>org.allenai</groupId>
  <artifactId>science-parse_2.12</artifactId>
  <version>3.0.1</version>
</dependency>
```

The first time you run it, SP will download some rather large model files. Don't be alarmed! The model files are cached, and startup is much faster the second time.

For licensing reasons, SP does not include libraries for some image formats. Without these
libraries, SP cannot process PDFs that contain images in these formats. If you have no
licensing restrictions in your project, we recommend you add these additional dependencies to your
project as well:
```
  "com.github.jai-imageio" % "jai-imageio-core" % "1.2.1",
  "com.github.jai-imageio" % "jai-imageio-jpeg2000" % "1.3.0", // For handling jpeg2000 images
  "com.levigo.jbig2" % "levigo-jbig2-imageio" % "1.6.5", // For handling jbig2 images
```

## Development

This project is a hybrid between Java and Scala. The interaction between the languages is fairly seamless, and SP can be used as a library in any JVM-based language.

Our build system is sbt. To build science-parse, you have to have sbt installed and working. You can
find details about that at https://www.scala-sbt.org.

Once you have sbt set up, just start `sbt` in the main project folder to launch sbt's shell. There
are many things you can do in the shell, but here are the most important ones:
 * `+test` runs all the tests in all the projects across Scala versions.
 * `cli/assembly` builds a runnable superjar (i.e., a jar with all dependencies bundled) for the
   project. You can run it (from bash, not from sbt) with `java -Xmx10g -jar <location of superjar>`.
 * `server/assembly` builds a runnable superjar for the webserver.
 * `server/run` starts the server directly from the sbt shell.

### Lombok

This project uses [Lombok](https://projectlombok.org) which requires you to enable annotation processing inside of an IDE.
[Here](https://plugins.jetbrains.com/plugin/6317) is the IntelliJ plugin and you'll need to enable annotation processing (instructions [here](https://www.jetbrains.com/idea/help/configuring-annotation-processing.html)).

Lombok has a lot of useful annotations that give you some of the nice things in Scala:

* `val` is equivalent to `final` and the right-hand-side class. It gives you type-inference via some tricks
* Check out [`@Data`](https://projectlombok.org/features/Data.html)

## Thanks

Special thanks goes to @kermitt2, whose work on [kermitt2/grobid](https://github.com/kermitt2/grobid) inspired Science Parse, and helped us get started with some labeled data.

Releasing new versions
----------------------

This project releases to BinTray.  To make a release:

1. Pull the latest code on the master branch that you want to release
1. Tag the release `git tag -a vX.Y.Z -m "Release X.Y.Z"` replacing X.Y.Z with the correct version
1. Push the tag back to origin `git push origin vX.Y.Z`
1. Release the build on Bintray `sbt +publish` (the "+" is required to cross-compile)
1. Verify publication [on bintray.com](https://bintray.com/allenai/maven)
1. Bump the version in `build.sbt` on master (and push!) with X.Y.Z+1 (e.g., 2.5.1 after
 releasing 2.5.0)

If you make a mistake you can rollback the release with `sbt bintrayUnpublish` and retag the
 version to a different commit as necessary.
