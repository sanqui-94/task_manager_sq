class TaskCodeGenerator
  def self.next!(prefix:)
    TaskCodeSequence.transaction do
      sequence = TaskCodeSequence.lock.find_or_create_by!(prefix: prefix) do |record|
        record.last_number = 0
      end
      sequence.increment!(:last_number)
      format_code(prefix, sequence.last_number)
    end
  end

  def self.format_code(prefix, number)
    "#{prefix}-#{number.to_s.rjust(3, '0')}"
  end
end
