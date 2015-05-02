shared_examples 'an existing directory' do
  it { Array(path).each { |p| expect(File).to be_directory(p) } }
end

shared_examples 'a non-existing directory' do
  it { Array(path).each { |p| expect(File).not_to be_exist(p) } }
end
