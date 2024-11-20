package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import db.DBConnection;

public class EditarPerfilUsuario extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = Logger.getLogger(EditarPerfilUsuario.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Obtén el idusuario de la sesión como Integer y conviértelo a String
        Integer idusuarioInt = (Integer) session.getAttribute("idusuario");
        String idusuario = idusuarioInt != null ? idusuarioInt.toString() : null;
        
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String celular = request.getParameter("celular");
        String fechanacimiento = request.getParameter("fechanacimiento");
        String tipo = request.getParameter("tipo");

        LOGGER.info("Datos recibidos: ID Usuario=" + idusuario + ", Nombres=" + nombres + ", Apellidos=" + apellidos + ", Celular=" + celular + ", Fecha de Nacimiento=" + fechanacimiento + ", Tipo=" + tipo );

        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = DBConnection.getConnection();

            if (idusuario == null || nombres == null || nombres.isEmpty() ||
                apellidos == null || apellidos.isEmpty() || celular == null || celular.isEmpty() ||
                fechanacimiento == null || fechanacimiento.isEmpty() || tipo == null || tipo.isEmpty()) {
                throw new IllegalArgumentException("Todos los campos deben ser completados.");
            }

            String query = "UPDATE usuario SET nombres = ?, apellidos = ?, celular = ?, fechanacimiento = ?, tipo = ? WHERE idusuario = ?";
            stmt = con.prepareStatement(query);
            stmt.setString(1, nombres);
            stmt.setString(2, apellidos);
            stmt.setString(3, celular);
            stmt.setString(4, fechanacimiento);
            stmt.setString(5, tipo);
            stmt.setInt(6, idusuarioInt);  // Ajuste aquí para utilizar setInt con el valor de Integer

            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                LOGGER.info("Perfil profesional actualizado correctamente para el ID: " + idusuario);
                request.setAttribute("mensaje", "Datos actualizados correctamente.");

                // Actualiza los datos de sesión
                session.setAttribute("nombres", nombres);
                session.setAttribute("apellidos", apellidos);
                session.setAttribute("celular", celular);
                session.setAttribute("fechanacimiento", fechanacimiento);
                session.setAttribute("tipo", tipo);
            } else {
                LOGGER.warning("No se encontró el profesional para actualizar. ID Usuario: " + idusuario);
                request.setAttribute("mensaje", "No se pudo actualizar el perfil. Verifique los datos.");
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error SQL al actualizar los datos del profesional", e);
            request.setAttribute("mensaje", "Error en la base de datos: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Datos de entrada no válidos: " + e.getMessage(), e);
            request.setAttribute("mensaje", "Error en los datos de entrada: " + e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error inesperado", e);
            request.setAttribute("mensaje", "Ocurrió un error inesperado: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error al cerrar la conexión o el statement", e);
            }
        }

        request.getRequestDispatcher("perfilusuario.jsp").forward(request, response);
    }
}
