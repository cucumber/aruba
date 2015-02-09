shared_examples 'an existing file' do
  it { Array(file_path).each { |p| expect(File).to be_exist(p) } }
end
