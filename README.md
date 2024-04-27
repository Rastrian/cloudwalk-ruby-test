# Cloudwalk Software Engineering Test

- [Specification](https://gist.github.com/cloudwalk-tests/704a555a0fe475ae0284ad9088e203f1)

## Author

- [Luis Vaz - Rastrian](https://github.com/Rastrian)

## How to run

There are two projects, the first-try challenge implementation and the final implementation. Both are Ruby projects, so you need to have Ruby installed on your machine.
The folder ``sample-outputs`` contains the output of the parser for the provided log file generated by my machine.

## Requirements

- Ruby 2.7.2
- Bundler
- Gemfile

## Installation

### About final working project and how to execute it

This is the final implementation of the challenge. It is a Ruby project that parses Quake game log files to extract and report game statistics.

To run it, execute the following commands:

Install the dependencies using bundler:

```bash
bundle install
```

Run the parser using:

```bash
chmod +x ./quake_log_parser/bin/run_parser && ./quake_log_parser/bin/run_parser ./quake.log > output.json
```

The file ``output.json`` will be created with the output of the parser.

### About first implementation script and how to execute it

This is the first implementation of the challenge. It is a simple implementation that reads the log file and prints the output to the console.
It's a little bit wrong because i was just playing with the challenge for a first sight implementation, but i think that it's worth to keep it here, it was fun.

To run it, execute the following command:
```bash
ruby first-try/quake_parser_final.rb quake.log > output-first-try.json
```

The file ``output-first-try.json`` will be created with the output of the parser.