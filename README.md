# TimeSampler Desktop (WIP)

## Installation

```
npm install -g electron
bundle install
./bin/build; ./bin/start
```

## Development

watching for changes (requires [fswatch](https://github.com/emcrisostomo/fswatch)):

```ruby
fswatch -r ./src | ruby -ne 'system "p $_; ./bin/build"; p [:built, $_]'
```

