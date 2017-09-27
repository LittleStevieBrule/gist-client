require_relative 'spec_helper'

context 'cs496 tests' do

  before :all do
    @my_user = GistWrapper.user
  end

  before :each do
    @gist_content = {
      description: 'the description for this gist',
      public: true,
      files: {
        gist_name: {
          content: Time.now.to_s
        }
      }
    }
  end

  it '1. Getting public Gists returns 30 Gists' do
    public_gists = GistWrapper.public_gists
    expect(public_gists.length).to eq 30
  end

  it '2. The user `wolfordj` has at least one public Gist' do
    wolfordj = GistWrapper.user username: 'wolfordj'
    expect(wolfordj.gist?).to eq true
  end

  it '3. When you create a Gist the number of Gists associated to your
      account increases by 1' do
    before = @my_user.gists.length
    begin
      response = @my_user.create_gist(@gist_content)
      after = @my_user.gists.length
    ensure
      @my_user.delete_gist(id: response[:id])
    end
    expect(after).to eq(before + 1)
  end

  it '4. The contents of the Gist you created match the contents you send' do
    begin
      id = @my_user.create_gist(@gist_content)[:id]
      content = @my_user.gist(id: id).content
    ensure
      @my_user.delete_gist(id: id)
    end
    expect(content).to eq @gist_content[:files][:gist_name][:content]
  end

  it '5. You are able to edit the contents of a Gist' do
    begin
      id = @my_user.create_gist(@gist_content)[:id]
      @my_user.edit_gist(id: id,
                         files: { gist_name: { content: 'updated content' } })
      content = @my_user.gist(id: id).content
    ensure
      @my_user.delete_gist(id: id)
    end
    expect(content).to eq 'updated content'
  end

  it '6. You can add a star to a Gist' do
    begin
      gist = @my_user.create_gist(@gist_content)
      @my_user.star_gist id: gist[:id]
      result = @my_user.gist_starred? id: gist[:id]
    ensure
      @my_user.delete_gist(id: gist[:id])
    end
    expect(result).to eq true
  end

  it '7. list of Starred gists is correct' do
  end

  it '8. You can remove a star from a Gist' do
    raise 'TODO'
  end

  it '9. You can delete a Gist' do
    begin
      id = @my_user.create_gist(@gist_content)[:id]
    ensure
      @my_user.delete_gist(id: id)
    end
    my_gist_ids = @my_user.gists.map { |gist| gist[:id] }
    expect(my_gist_ids.include?(id)).to eq false
  end

end
