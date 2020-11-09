# frozen_string_literal: true

require 'active_support/core_ext/numeric/time'

class DownloadsTestHelper < BaseTestHelper
  DOWNLOADS_DIR = Pathname.new(__dir__).join('../tmp', "capybara_downloads#{ ENV['TEST_ENV_NUMBER'] }")
  DOWNLOAD_WAIT_TIME = 5.seconds

# Getters: A convenient way to get related data or nested elements.
  private \
  def downloaded_files
    Dir.glob(DOWNLOADS_DIR.join('*')).sort_by { |path| file_timestamp(path) }.reverse
  end

  private \
  def file_timestamp(path)
    File.mtime(path)
  rescue StandardError
    5.years.from_now
  end

  # Public: Returns the path for the last downloaded file.
  def downloaded_file_path(name: nil, extension: nil, wait: DOWNLOAD_WAIT_TIME)
    synchronize_expectation(wait: wait) {
      expect(downloaded_files).to be_present, "No download files in #{ DOWNLOADS_DIR }"
      file_path = downloaded_files.find { |file| file.include?(name.to_s) && file.include?(extension.to_s) } || downloaded_files.first
      expect(file_path).not_to include('.part'), "Incomplete download file: #{ file_path.inspect }"
      expect(file_path).not_to include('crdownload'), "Incomplete download file: #{ file_path.inspect }"
      expect(file_path).to include(name), "Download does not match #{ name.inspect } name: #{ file_path.inspect }" if name
      expect(file_path).to match(/\.#{ extension }$/), "Download does not match .#{ extension } extension: #{ file_path.inspect }" if extension
      file_path
    }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def create_download_dir
    FileUtils.mkdir_p(DOWNLOADS_DIR)
    delete_earlier_downloads
  end

  def delete_earlier_downloads
    FileUtils.rm Dir.glob(DOWNLOADS_DIR.join('*'))
  end

  def delete_download_dir
    FileUtils.remove_dir(DOWNLOADS_DIR) if Dir.exist?(DOWNLOADS_DIR)
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def should_have_file_by_name(filename, **options)
    name, extension = filename.split('.')
    downloaded_filename = File.basename(downloaded_file_path(extension: extension, **options))

    # Since the current date is inserted into file names, we are matching using regex.
    expect(downloaded_filename).to match(/^#{ name }/)
  end
end
