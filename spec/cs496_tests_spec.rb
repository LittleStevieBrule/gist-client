require_relative 'spec_helper'

context 'cs496 tests' do

  # Getting public Gists returns 30 Gists (you can get more via pagination,
  # but you just need to get the first 30 and confirm that there are 30)
  it 'Should return 30 Gists' do

  end

  # Confirm that the user `wolfordj` has at least one public Gist
  it 'should return a users Gists' do
    my_user = OctokitWrapper.user
    my_gists = my_user.gists
  end

  # Confirm that when you create a Gist the number of Gists associated to your
  # account increases by 1
  it 'should increment Gist count' do

  end

  # Confirm that the contents of the Gist you created match the contents you
  # send
  it 'should create a Gist' do
    my_user = OctokitWrapper.user
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
  end

  # Confirm that you are able to edit the contents of a Gist (this will require
  # editing it and proving the edits worked)
  it 'should edit a Gists' do

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

  end

end
