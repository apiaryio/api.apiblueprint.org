# API Blueprint API

[![Apiary Documentation](https://img.shields.io/badge/Apiary-Documented-blue.svg)](http://docs.apiblueprint.apiary.io/)

This repository contains the API Blueprint for the API Blueprint parsing service.
You can find the documentation for the parsing service on
[Apiary](http://docs.apiblueprint.apiary.io/).

## Usage

The API Blueprint uses [hercule](https://github.com/jamesramsay/hercule) to
transclude multiple files into the blueprint. To build the blueprint you
will need to install Node, then you can run the following to build the
`apiary.apib` blueprint:

```shell
$ make
Transcluding API Blueprint
```
