# Webserver log statistics

This script outputs summaries of website usage, taking a logfile as input. The logfile consists of an arbitrary number of lines, each containing a URL path followed by a space then an IP address. The output consists of a list of all paths visited, with total number of visits or unique visits from different IP addresses, order by totals.

## Usage

You can run the script in your console on Mac or Linux, and in Windows Subsystem for Linux on Windows. Windows OS usage is untested.

Before using the program, you'll need to download the code and open a shell console in the download root. You will need a recent version of Ruby installed - this was written using Ruby 2.7.1.

```sh
bundle install
parser.rb webserver.log # runs with the sample logfile
```

A sample logfile is included at [webserver.log](webserver.log).

## Logfile format

The logfile should be a text file (UTF-8 is fine) consisting of a list of page requests, one per line. Each line consists of a valid path, then a space, then a valid IPv4 address. For example:

```
/home 382.335.626.855
/index 929.398.951.889
/index 715.156.286.412
/help_page/1 382.335.626.855
```

The sample file uses a LF character to separate each line, but CRLF line-ends, as used on Windows, should also work fine.

## Output format

The output will be sent to stdout (i.e. the console you're running the script in). The output will consist of two lists:

* One for the total number of visits to each path (i.e. the number of times each path appears in the input file)
* One for the total number of unique visits to each path (i.e. the number of different IP addresses that appear next to each path in the input file)

Each list will be ordered by the relevant total, most visits first. Each line in the list will consist of the path, then a space, then the relevant total.

## Testing

Program functionality is tested with RSpec. From the root directory, run:

```sh
rspec
```

All tests should pass. SimpleCov is enabled and the RSpec report should include test coverage.

### Feature testing

Feature specs should interact with an application via its external interface. Since our interface is a Ruby script executed via command line, we call the script as a new process via `system ruby` and test the output to stdout or stderr. The log files are:

* A tiny log file - [spec/fixtures/tiny.log](spec/fixtures/tiny.log) to exercise basic file access tests
* A small log file - [spec/fixtures/small.log](spec/fixtures/small.log) producing output consistent with [spec/fixtures/small_summary.txt](spec/fixtures/small_summary.txt)

## Assumptions and architecture

The key decision point in picking a suitable architecture is whether the application should be able to cope with arbitrarily large logfiles. The simplest solution would rely on reading the entire logfile into memory using e.g. `File.readlines`, then transforming the data afterwards and producing output. I decided to build for a solution that reduces memory usage by processing the log during load using `File#each`. 

I can see three levels of efficiency, and am targeting the second:

1. Log files of e.g. a few million visits are fine for loading the full file directly, and processing in-memory. Populating an array with even a hundred million elements is manageable and takes less than half a minute on most modern desktop computers
1. For larger files, there should be some benefit to loading the data into memory one line at a time, and storing in a processed form. To measure unique visits, we would still have to store individual IPs visiting each path. This could become taxing for large enough logfiles
1. Very large log files could not be loaded into memory all in one go. Instead we'd need to look at processing logfiles into intermediate files where visits were grouped by path and IP, then into files containing per-path totals. If we were looking at logfiles of that size, though, a Ruby script might not be the best solution in general, and displaying a list of paths in the console would be pointless

An outline list of classes might be:

* Parser - the external interface; accepts input and returns output
* PathList - store and manipulate the set of paths
* Report - inserts list totals into a template for output to the console

Creating individual PathItem objects for each path in the PathList object would result in better-formed OO code, but the weight of creating a new class instance for every path in a log file would likely reduce the code's efficiency.

## Development tasks

- [x] Install Ruby, RSpec, initial test setup confirming a script exists and executes correctly without arguments
- [x] Add code coverage checks
- [x] Add a basic logfile, expected output, and feature test to drive feature development
- [ ] Accept a filename input, and throw an error if the filename or the file don't exist
- [ ] Parse file lines into a PathList object, with many visits to each unique path
- [x] Summarise the PathList data as total and total unique visits per path
- [x] Output summary data as a Report in the correct format
- [ ] tbc

## 'Extra credit' tasks

- [ ] Sort results alphanumerically within sets of paths that have the same totals 
- [ ] Add flags to the command line to show only total visits, and only total unique visits
- [ ] Add a help flag to the command line with usage instructions
- [ ] Ensure CRLF and LF both work for input file format
- [ ] Build code to generate arbitrarily large logfiles for load testing purposes, and ensure the script performs well under load
- [ ] Parse all valid path possibilities correctly, i.e. paths with space characters or other special characters
- [ ] Validate URL paths to the official standard
- [ ] Validate IPv4 addresses to the official standard
- [ ] Add parsing of correctly formed IPv6 addresses
- [ ] Fail gracefully during parsing, and exclude unparseable data from summaries
- [ ] Report on parsing failures; add a strict-mode flag that fails if unparseable or invalid data is encountered
- [ ] Confirm Windows command line compatibility

## Versioning

This is currently pre-alpha, and has no version. Version tracking will be [SemVer](https://semver.org/) once an initial version is released.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details