shared_examples 'an existing file' do
  it { Array(file_path).each { |p| expect(File).to be_exist(p) } }
end

shared_examples 'a non-existing file' do
  it { Array(file_path).each { |p| expect(File).not_to be_exist(p) } }
end
