# Webserver log statistics

This script outputs summaries of website usage, taking a logfile as input. The logfile consists of an arbitrary number of lines, each containing a URL path followed by a space then an IP address. The output consists of a list of all paths visited, with total number of visits or unique visits from different IP addresses, order by totals.

## Usage

You can run the script in your console on Mac or Linux, and in Windows Subsystem for Linux on Windows. Windows OS usage is untested.

Before using the program, you'll need to download the code and open a shell console in the download root. You will need a recent version of Ruby installed - this was written using Ruby 2.7.1.

```sh
bundle install
parser.rb # runs with the sample logfile
```

A sample logfile is included at [webserver.log](webserver.log), and will be used by default if an input filename is not provided as an argument to the command.

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

Each list will be ordered by the relevant total, most visits first. Each line in the list will consist of the path, then a space, then the IP address.

## Testing

Program functionality is tested with RSpec. From the root directory, run:

```sh
rspec
```

All tests should pass. SimpleCov is enabled and the RSpec report should include test coverage.

## Development tasks

- [x] Install Ruby, RSpec, initial test setup confirming a script exists and executes correctly without arguments
- [x] Add code coverage checks
- [ ] Accept a filename input, and throw an error if the filename doesn't exist
- [ ] tbc

## 'Extra credit' tasks

- [ ] Sort results alphanumerically within sets of paths that have the same totals 
- [ ] Add flags to the command line to show only total visits, and only total unique visits
- [ ] Ensure CRLF and LF both work for input file format
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