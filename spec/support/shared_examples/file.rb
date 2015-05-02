shared_examples 'an existing file' do
  it { Array(path).each { |p| expect(File).to be_file(p) } }
end

shared_examples 'a non-existing file' do
  it { Array(path).each { |p| expect(File).not_to be_exist(p) } }
end
