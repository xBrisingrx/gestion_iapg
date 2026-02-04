class PriceCoursePolicy < ApplicationPolicy
  def initialize(user, price_course)
    @user = user
    @price_course = price_course
  end

  def index?
    user.admin? || user.editor?
  end

  def show?
    index?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    user.admin?
  end

  def edit?
    update?
  end
  class Scope < ApplicationPolicy::Scope
  end
end
