# frozen_string_literal: true

module SupportFileHelpers
  def support_file_path(*name)
    Pathname.new(__dir__).join('files', *name)
  end

  def support_file(*name)
    File.open support_file_path(*name)
  end
end
