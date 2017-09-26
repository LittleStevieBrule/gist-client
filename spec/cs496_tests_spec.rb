require_relative 'spec_helper'

context 'cs496 tests' do

  it '1. Getting public Gists returns 30 Gists' do
    public_gists = GistWrapper.public_gists
    expect(public_gists.length).to eq 30
  end

  it '2. The user `wolfordj` has at least one public Gist' do
    my_user = GistWrapper.user username: 'wolfordj'
    expect(my_user.gist?).to eq true
  end


  it '3. When you create a Gist the number of Gists associated to your
      account increases by 1' do
    my_user = GistWrapper.user
    before = my_user.gists.length
    content = {
      description: 'the description for this gist',
      public: true,
      files: {
        Time.now.to_s => {
          content: 'String file contents'
        }
      }
    }
    response = my_user.create_gist(content)
    after = my_user.gists.length
    my_user.delete_gist(gist: response[:id])
    expect(after).to eq(before + 1)
  end

  it '4. The contents of the Gist you created match the contents you send' do

  end

  # Confirm that you are able to edit the contents of a Gist (this will require
  # editing it and proving the edits worked)
  it '5. You are able to edit the contents of a Gist' do

  end

  # Confirm that you can add a star to a Gist
  # Confirm that your list of Starred gists is correct
  it 'should add a star to a Gist' do

  end
  # Confirm you can remove a star from a Gist
  it 'should remove a star from a Gist' do

  end
  # Confirm you can delete a Gist
  it 'should delete a Gist' do
    my_user = GistWrapper.user
    content = {
      description: 'the description for this gist',
      public: true,
      files: {
        Time.now.to_s => {
          content: 'String file contents'
        }
      }
    }
    gist_id = my_user.create_gist(content)[:id]
    my_user.delete_gist(gist: gist_id)
    my_gist_ids = my_user.gists.map { |gist| gist[:id] }
    expect(my_gist_ids.include?(gist_id)).to eq false
  end

end
