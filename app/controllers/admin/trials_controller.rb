class Admin::TrialsController < AdminController

  expose(:trials) { Trial.all }

  def index

  end

end
