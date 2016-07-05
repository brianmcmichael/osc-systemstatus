class PagesController < ApplicationController

  def index

    @clusters = Hash.new

    OODClusters.each do |key, cluster|
     if cluster.ganglia_server?
       ganglia_cluster = Hash.new
       ganglia_cluster[:name] = key
       begin
         showqer = Showqer.new key.to_s
         showqer.setup
       rescue Exception => e
         logger.error "Loading Oakley showq data failed #{e.message}"
         logger.error e.backtrace.join("\n")
         flash.now[:alert] = "Error loading showq data."
         showqer = ShowqerNotAvailable.new
       end
       ganglia_cluster[:showqer] = showqer
       @clusters[key] = ganglia_cluster
     end
    end
  end

  def oakley
    @ganglia = Ganglia.new('oakley')
    render "system_status"
  end

  def ruby
    @ganglia = Ganglia.new('ruby')
    render "system_status"
  end

  def about
  end
end
