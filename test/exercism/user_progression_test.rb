require_relative '../test_helper'
require_relative '../x_helper'
require_relative '../integration_helper'

class UserProgressionTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @user = User.create
    @f= './test/fixtures/xapi_v3_tracks.json'
  end

  def test_user_progress_for_100_percent
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      UserExercise.create(user: @user, language: 'Animal', iteration_count: 1)
      actual = UserProgression.user_progress(@user)
      assert_equal 'Animal', actual.first.language
      assert_equal 1, actual.first.user_exercises.count
      assert_equal 1, actual.first.language_track.count
    end
  end

  def test_user_progress_for_1_out_of_4
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      UserExercise.create(user: @user, language: 'Fake', iteration_count: 1)
      actual = UserProgression.user_progress(@user)
      assert_equal 'Fake', actual.first.language
      assert_equal 1, actual.first.user_exercises.count
      assert_equal 4, actual.first.language_track.count
    end
  end

  def test_user_progress_ignores_exercises_without_iterations
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      UserExercise.create(user: @user, language: 'Fake')
      actual = UserProgression.user_progress(@user)
      assert_equal [], actual
    end
  end

  def test_user_progress_for_0_percent
    X::Xapi.stub(:get, [200, File.read(@f)]) do
      actual = UserProgression.user_progress(@user)
      assert_equal actual, []
    end
  end
end
