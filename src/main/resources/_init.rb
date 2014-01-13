include Java
import javax.servlet.http.HttpServlet # for the convenience of every servlet

class InnerServlet < javax.servlet.GenericServlet
  def init(config)
    super
    @servlets = {}
  end

  def destroy
    log("destroy: %p" % @servlets)
    @servlets.each_value {|s| s.destroy}
    super
  end

  def service(req, res)
    begin
      log("request: %p %p from: %p" %
          [req.requestURI, req.query_string, req.remote_host])
      servlet = nil
      self.synchronized {
        name = req.servlet_path[1..-4] # "/Poi.rb" => "Poi"
        servlet = @servlets[name]
        if servlet.nil?
          log("required: %p" % name)
          require name
          servlet = Object.const_get(name).new
          @servlets[name] = servlet
          servlet.init(self)
        end
      }
      case req.method
      when "GET" then servlet.doGet(req, res)
      when "POST" then servlet.doPost(req, res)
      else raise("unexpected method %p" % req.method)
      end
    rescue => ex
      log(ex.inspect + " at " + ex.backtrace.join("\n\tfrom "))
      raise
    end
  end
end