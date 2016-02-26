# Various test utilities used in the unit tests.

require 'fileutils'

class TestUtils
  # Directory to generate the question files to in the tests.
  GENERATE_QUESTION_FILES_DIR = "questiongenerator_temp"

  def self.create_test_dir
    Dir.mkdir(GENERATE_QUESTION_FILES_DIR)
  end

  def self.remove_test_dir
    FileUtils.rm_rf(GENERATE_QUESTION_FILES_DIR)
  end

end
