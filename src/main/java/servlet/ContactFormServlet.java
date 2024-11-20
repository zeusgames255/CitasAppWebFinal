package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class ContactFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ContactFormServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los datos del formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String mensaje = request.getParameter("mensaje");

        // Configuración del servidor SMTP
        String host = "smtp.gmail.com";  // Cambia a tu servidor SMTP
        String from = "agendame.citas@gmail.com"; // El correo que envía el mensaje
        String pass = "Citas.agendame12.*.";  // La contraseña de la cuenta desde donde enviarás el correo
        String to1 = "artuzehe@gmail.com"; // Primer correo donde deseas recibir los mensajes
        String to2 = "ernesto96_329@patyc.org"; // Segundo correo donde deseas recibir los mensajes

        // Configuración de propiedades para la conexión SMTP
        Properties properties = System.getProperties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");

        // Crear una sesión de correo con autenticación
        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass);
            }
        });

        try {
            // Crear el mensaje de correo
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to1));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to2));
            message.setSubject("Nuevo mensaje de contacto");
            message.setText("Nombre: " + nombre + "\nCorreo: " + email + "\nMensaje: " + mensaje);

            // Enviar el correo
            Transport.send(message);

            // Redirigir a una página de éxito
            response.sendRedirect("mensajeenviado.jsp");

        } catch (MessagingException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
