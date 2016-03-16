task default: :test
task default: :rubocop

desc 'Run tests'
task :test do
  sh "bundle exec mrspec"
end

desc 'Run rubocop'
task :rubocop do
  sh "bundle exec rubocop ~/WebNotes"
end
