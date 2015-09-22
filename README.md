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
fswatch -r ./src | ruby -ne 'p $_; system "./bin/build"; p [:built, $_]'
```

