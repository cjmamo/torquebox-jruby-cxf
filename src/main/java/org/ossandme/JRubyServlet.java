package org.ossandme;

import org.jruby.Ruby;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.runtime.builtin.IRubyObject;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;


public class JRubyServlet extends HttpServlet {

    private Ruby ruby;
    private Servlet inner;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ruby = JavaEmbedUtils.initialize(new ArrayList<String>());
        IRubyObject ro = ruby.evalScriptlet("require '_init'; InnerServlet.new");
        inner = (Servlet) JavaEmbedUtils.rubyToJava(ruby, ro, Servlet.class);
        inner.init(config);
    }

    @Override
    public void destroy() {
        inner.destroy();
        JavaEmbedUtils.terminate(ruby);
        super.destroy();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        inner.service(req, res);
    }

}
