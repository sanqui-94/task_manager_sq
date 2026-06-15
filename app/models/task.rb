class Task < ApplicationRecord
  DEFAULT_PREFIX = "GT"

  PRIORITY_ORDER = Arel.sql("CASE priority WHEN 0 THEN 0 WHEN 1 THEN 1 WHEN 2 THEN 2 END")

  belongs_to :user
  has_many :comments, dependent: :destroy

  enum :status, { todo: 0, in_progress: 1, done: 2 }
  enum :priority, { high: 0, medium: 1, low: 2 }

  validates :title, presence: true
  validates :code, presence: true, uniqueness: true

  before_validation :assign_code, on: :create

  scope :active, -> { where(archived: false) }
  scope :archived_records, -> { where(archived: true) }
  scope :by_column, ->(status) { where(status: status) }
  scope :stack_ordered, -> { order(PRIORITY_ORDER, created_at: :desc) }
  scope :with_priorities, ->(priorities) {
    return all if priorities.blank?

    where(priority: priorities)
  }

  def archive!
    update!(archived: true, archived_at: Time.current)
  end

  def unarchive!
    update!(archived: false, archived_at: nil)
  end

  def to_param
    code
  end

  private

    def assign_code
      return if code.present?

      self.code = TaskCodeGenerator.next!(prefix: DEFAULT_PREFIX)
    end
end
