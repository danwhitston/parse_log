# Webserver log statistics

This script outputs summaries of website usage, taking a logfile as input. The logfile consists of an arbitrary number of lines, each containing a URL path followed by a space then an IP address. The output consists of a list of all paths visited, with total number of visits or unique visits from different IP addresses, order by totals.

## Usage

You can run the script in your console on Mac or Linux, and in Windows Subsystem for Linux on Windows. Windows OS usage is untested.

Before using the program, you'll need to download the code and open a shell console in the download root. You will need a recent version of Ruby installed - this was written using Ruby 2.7.1.

```sh
bundle install
./parse_log.rb webserver.log # runs with the sample logfile
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

The output is sent to stdout (i.e. the console you're running the script in). The output consists of two lists:

* One for the total number of visits to each path (i.e. the number of times each path appears in the input file)
* One for the total number of unique visits to each path (i.e. the number of different IP addresses that appear next to each path in the input file)

Each list is ordered by the total visits, most visits first. Each line in the list consists of the path, then a space, then the relevant total. For example:

```
Page visits:
/index 4
/help_page/1 3
/home 1

Unique page visits:
/help_page/1 3
/index 2
/home 1
```

## Testing

Program functionality is tested with RSpec. From the root directory, run:

```sh
rspec
```

SimpleCov is enabled and running RSpec will generate a test coverage report in the coverage folder. All tests should pass, and the code has 100% coverage. Note however that SimpleCov is currently filtering out the `parse_log.rb` script in root.

### Feature testing

Feature specs should interact with an application via its external interface. Since our interface is a Ruby script executed via command line, we call the script as a new process via `system ruby` and test the output to stdout or stderr.

The feature test makes use of a small log file - [spec/fixtures/small.log](spec/fixtures/small.log) producing output consistent with [spec/fixtures/small_summary.txt](spec/fixtures/small_summary.txt).

## Assumptions and architecture

The key decision point in picking a suitable architecture is whether the application should be able to cope with arbitrarily large logfiles. The simplest solution would rely on reading the entire logfile into memory using e.g. `File.readlines`, then transforming the data afterwards and producing output. I decided to build for a slightly more scalable solution that reduces memory usage by processing the log during load using `File#each`. 

This architecture does come with limitations. Very large log files cannot be loaded into memory all in one go. Instead we'd need to look at processing logfiles into intermediate files where visits were grouped by path and IP, then into files containing per-path totals. If we were looking at logfiles of that size, though, a Ruby script might not be the best solution in general, and displaying a list of paths in the console would be pointless.

The software structure is:

* `parse_log.rb` - the command-line script, accepts filename, opens file, instantiates objects and outputs parsed data
* `lib/parser.rb` - Parser module accepts input and returns output. This was extracted from parse_log to keep the code clean and make testing easier
* `lib/path_list.rb` - PathList class stores and summarises the paths and visits by individual IP addresses
* `lib/report.rb` - Report class inserts list summaries into a template for output to the console

Creating individual PathItem objects for each path in the PathList object would result in better-formed OO code as IP address storage for each path arguably violates SRP, but I suspect the weight of creating a new class instance for every path in a log file would reduce the code's efficiency.

## Development tasks

- [x] Install Ruby, RSpec, initial test setup confirming a script exists and executes correctly without arguments
- [x] Add code coverage checks
- [x] Add a basic logfile, expected output, and feature test to drive feature development
- [x] Accept a filename input, and throw an error if the filename or the file don't exist
- [x] Parse file lines into a PathList object, with many visits to each unique path
- [x] Summarise the PathList data as total and total unique visits per path
- [x] Output summary data as a Report in the correct format
- [x] Working solution accepting a filename and outputting page views and unique page views

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

## Version

This is version 1.0.0. Version tracking follows [SemVer](https://semver.org/), and each release is tagged on the repository. There is no CHANGELOG at present.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details