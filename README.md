# docker-python

Dockerised Python designed for multi-runtime builds with common testing utilities pre-installed. Built to enable matrix-build like experience using CODESIGN2/docker-jenkins

[![Build Status](https://travis-ci.org/CODESIGN2/docker-python.svg?branch=master)](https://travis-ci.org/CODESIGN2/docker-python)

## Using

Probably best to build using your own derrived image. This was done as an experiment to deepen & evidence Jenkins CI expertise. 

It's used internally, but will maybe be revisited 1-2 times per-year.

No public real-world usage currently exists, but [open an issue](/CODESIGN2/docker-python/issues) if you want to be the first. Reading through [php-ulid](https://github.com/Lewiscowles1986/php-ulid/blob/3358ae90d67474ddf9ce96753110459136b9eb76/Jenkinsfile) you should get an idea for the parts involved.

You don't need to run multiple runtimes in parallel, but it cuts down time testing, and can be used as a roadmapping tool.

## Notes / Troubleshooting

- Not all dependencies will be available for all platforms. 2.7 is expected to EOL in 2020 for example so at that point it will be available on dockerhub, but removed from the travis.yml
- Older Python is currently not an option, so the 2.6 & < 3.5 releases are unavailable
