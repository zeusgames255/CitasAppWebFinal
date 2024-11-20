<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="db.DBConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Expires", "0");
    response.setDateHeader("Expires", -1);

    if (session.getAttribute("nombreusuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer idusuario = (Integer) session.getAttribute("idusuario");
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.9.1/font/bootstrap-icons.min.css">

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .card-calendar {
            border: 1px solid #000;
            margin: 15px 0;
            background-color: #e0e0e0;
        }
        .card-header {
            background-color: #343a40;
            color: #fff;
            text-align: center;
        }
        .btn-detalle, .btn-modificar, .btn-eliminar {
            background-color: #343a40;
            color: #fff;
            margin-right: 5px;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .btn:hover {
            background-color: #28a745;
            color: white;
            font-weight: bold;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-color: #28a745;
        }
   
        .custom-border {
            border: 1px solid #000 !important;
        }
        .card-img-top {
            transition: transform 0.3s ease;
        }
        .card-img-top:hover {
            transform: scale(1.05);
        }
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
        .alert {
            width: 50%;
            margin: 20px auto;
            padding: 15px;
            border: 1px solid #28a745;
            background-color: #d4edda;
            color: #155724;
            border-radius: 5px;
            text-align: center;
            position: relative;
        }

        .alert::before {
            content: "";
            display: block;
            width: 30px;
            height: 4px;
            background-color: #28a745;
            margin: 0 auto 10px;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            border: none;
            background: none;
            color: #155724;
            font-size: 16px;
            cursor: pointer;
        }

        .avatar-option {
            cursor: pointer;
            border: 2px solid transparent;
            transition: border 0.3s;
        }
        .avatar-option:hover {
            border: 2px solid #007bff; /* Color al pasar el ratón */
        }
        .selected {
            border: 2px solid #007bff; /* Color del borde para el avatar seleccionado */
        }
        .avatar-option {
    width: 100px; /* Ajusta el tamaño según sea necesario */
    height: 100px; /* Mantiene el mismo tamaño para ancho y alto */
    object-fit: cover; /* Asegura que la imagen cubra el contenedor sin distorsión */
    border-radius: 50%; /* Hace que la imagen sea circular */
    cursor: pointer; /* Cambia el cursor al pasar el ratón */
    
}

.avatar-option.selected {
    border: 2px solid #007bff; /* Resalta el avatar seleccionado */
}
    
    </style>
    
     <script>
        // Función para seleccionar un horario
        function seleccionarHorario(idhorario, dia, inicio, fin) {
            // Mostrar el horario seleccionado en el formulario
            document.getElementById("horarioSeleccionado").innerText = dia + ": " + inicio + " - " + fin;
            document.getElementById("diaSeleccionado").value = dia; // Guarda el día
            document.getElementById("horaSeleccionada").value = inicio; // Guarda la hora
            
            // NUEVO: Guarda el inicio en un campo oculto
            document.getElementById("inicioSeleccionado").value = inicio; // Guarda el inicio
            
            // NUEVO: Guarda el fin en un campo oculto
            document.getElementById("finSeleccionado").value = fin; // Guarda el fin
            
            // Guarda el idhorario en un campo oculto
            document.getElementById("idhorarioSeleccionado").value = idhorario; // Guarda el idhorario
            
            // Calcular la fecha del próximo día correspondiente
            const today = new Date();
            const dayOfWeek = today.getDay(); // 0=Domingo, 1=Lunes, ..., 6=Sábado
            
            // Mapear los días de la semana
            const dias = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
            const indexDia = dias.indexOf(dia);

            // Calcular los días restantes hasta el próximo día seleccionado
            const daysUntilNext = (indexDia - dayOfWeek + 7) % 7 || 7; // 7 para el próximo día si hoy es ese día
            
            today.setDate(today.getDate() + daysUntilNext);
            
            // Formatear la fecha en formato YYYY-MM-DD
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            const formattedDate = today.toLocaleDateString('en-CA', options).replace(/(\d{2})\/(\d{2})\/(\d{4})/, '$3-$1-$2');

            document.getElementById("fechaSeleccionada").value = formattedDate; // Guarda la fecha
            console.log("Fecha seleccionada:", formattedDate); // Verificar el valor de la fecha
        }
    </script>
</head>
<body>

<div style="background-color: #000000;">
    <div class="text-center py-3" style="background: linear-gradient(to bottom, #fafafa, #f5f5f5);">
        <img src="https://i.ibb.co/M1xqhhQ/logo-citas.png" class="img-fluid img-rounded" alt="Logo" width="900" height="250">
    </div>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="listarcitausuario.jsp">Mis Citas</a></li>
                    <li class="nav-item"><a class="nav-link active" href="crearcita.jsp">Crear cita</a></li>
                    <li class="nav-item"><a class="nav-link" href="listarprofesionalesusuario.jsp">Buscar Profesional</a></li>
                    <li class="nav-item"><a class="nav-link" href="perfilusuario.jsp">Mi Perfil</a></li>
                </ul>
                <ul class="navbar-nav ms-3">
                    <li class="nav-item d-flex align-items-center">
                        <div class="dropdown">
                            <button class="btn p-0" data-bs-toggle="dropdown" aria-expanded="false" style="border: none; background: none;">
                                <img src="<%= session.getAttribute("fotoperfil") != null ? session.getAttribute("fotoperfil") : "https://via.placeholder.com/40" %>" class="rounded-circle" alt="Avatar" width="40" height="40">
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="perfilusuario.jsp">Mi Perfil</a></li>
                                <li><a class="dropdown-item" href="eliminarcuenta.jsp">Eliminar Cuenta</a></li>
                                <li><a class="dropdown-item" href="CerrarSesion">Cerrar Sesión</a></li>
                            </ul>
                        </div>
                        <span class="text-white ms-2"><%= session.getAttribute("nombreusuario") %></span>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</div>


<div class="container my-5">
    <div class="card mx-auto">
        <div class="card-header">
            <h5 class="card-title">Registrar Cita</h5>
        </div>
        <div class="card-body">
            <%
                // Obtener el idprofesional de la URL
                String idProfesionalParam = request.getParameter("idprofesional");
                int idprofesional = (idProfesionalParam != null) ? Integer.parseInt(idProfesionalParam) : 0;

                if (idprofesional > 0) {
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DBConnection.getConnection();

                        // Consulta para obtener los horarios disponibles del profesional
                        String sql = "SELECT idhorarios, dia, inicio, fin, estado FROM horarios WHERE idprofesional = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, idprofesional);
                        rs = stmt.executeQuery();
            %>

            <h6>Horarios disponibles:</h6>
            <div class="list-group mb-3">
                <%
    // Mapeo de los días de la semana
    Map<String, Integer> diasSemana = new HashMap<>();
    diasSemana.put("Domingo", 0);
    diasSemana.put("Lunes", 1);
    diasSemana.put("Martes", 2);
    diasSemana.put("Miércoles", 3);
    diasSemana.put("Jueves", 4);
    diasSemana.put("Viernes", 5);
    diasSemana.put("Sábado", 6);
    
    // Obtener la fecha actual
    Calendar calendario = Calendar.getInstance();
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    
    // Mostrar cada horario obtenido de la base de datos
    while (rs.next()) { 
        int idhorario = rs.getInt("idhorarios");
        String dia = rs.getString("dia");
        String inicio = rs.getString("inicio");
        String fin = rs.getString("fin");
        String estado = rs.getString("estado"); // Obtener el estado del horario
        String etiquetaEstado = "Disponible";
        String claseEtiqueta = "badge bg-success"; // Clase por defecto para disponible
        
        if ("ocupado".equalsIgnoreCase(estado)) {
            etiquetaEstado = "Ocupado";
            claseEtiqueta = "badge bg-danger"; // Clase para ocupado
        }
        
        // Calcular la fecha correspondiente para el día de la semana
        int diaSemana = diasSemana.get(dia);
        int hoy = calendario.get(Calendar.DAY_OF_WEEK);
        int diferencia = diaSemana - hoy;
        
        if (diferencia < 0) {
            diferencia += 7; // Asegura que no pase al día siguiente de la semana
        }
        
        calendario.add(Calendar.DAY_OF_YEAR, diferencia); // Ajusta el calendario a la fecha del día deseado
        String fechaFormateada = dateFormat.format(calendario.getTime()); // Formato de la fecha

        // Volver a la fecha original
        calendario.add(Calendar.DAY_OF_YEAR, -diferencia);
%>
    <div class="list-group-item list-group-item-action <%= "ocupado".equalsIgnoreCase(estado) ? "disabled" : "" %>" 
         onclick="<%= "ocupado".equalsIgnoreCase(estado) ? "return false;" : "seleccionarHorario(" + idhorario + ", '" + dia + "', '" + inicio + "', '" + fin + "');" %>">
        <strong><%= dia %> (<%= fechaFormateada %>):</strong>
        <span><%= inicio %> - <%= fin %></span>
        <span class="<%= claseEtiqueta %> ms-2"><%= etiquetaEstado %></span>
    </div>
<% 
    } 
%>

            </div>

            <h6>Horario Seleccionado:</h6>
            <p id="horarioSeleccionado" class="fw-bold"></p>

            <% 
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<div class='alert alert-danger'>Ocurrió un error al conectar con la base de datos: " + e.getMessage() + "</div>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch(SQLException ignored) {}
                        if (stmt != null) try { stmt.close(); } catch(SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch(SQLException ignored) {}
                    }
                } else {
            %>
                <div class="alert alert-danger" role="alert">
                    Error: No se ha proporcionado un ID de profesional válido. Por favor, <a href="listarprofesionalesusuario.jsp">regrese</a> y seleccione un profesional.
                </div>
            <% 
                } 
            %>

            <!-- Formulario de registro de cita -->
            <form action="GuardarDatosCita" method="POST" onsubmit="return validarFormulario();">
                <input type="hidden" name="idusuario" value="<%= session.getAttribute("idusuario") %>">
                <input type="hidden" name="idprofesional" value="<%= idprofesional %>">

                <!-- Campos ocultos para enviar información al servlet -->
                <input type="hidden" id="diaSeleccionado" name="dia" />
                <input type="hidden" id="horaSeleccionada" name="hora" />
                <input type="hidden" id="fechaSeleccionada" name="fecha" /> <!-- Campo para la fecha -->
                <input type="hidden" id="inicioSeleccionado" name="inicio" /> <!-- NUEVO: Campo oculto para inicio -->
                <input type="hidden" id="finSeleccionado" name="fin" /> <!-- NUEVO: Campo oculto para fin -->
                <input type="hidden" id="idhorarioSeleccionado" name="idhorarios" /> <!-- NUEVO: Campo oculto para idhorario -->

                <div class="mb-3">
                    <label for="motivo" class="form-label">Motivo</label>
                    <input type="text" class="form-control" name="motivo" id="motivo" placeholder="Ingrese el motivo de la cita" required>
                </div>
                <div class="mb-3">
                    <label for="detalles" class="form-label">Detalles</label>
                    <textarea class="form-control" id="detalles" name="detalles" rows="3" placeholder="Ingrese detalles adicionales" required></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">Registrar</button>
            </form>

            <script>
                function validarFormulario() {
                    // Verifica si se ha seleccionado un horario
                    const horarioSeleccionado = document.getElementById("horarioSeleccionado").innerText;
                    const fechaSeleccionada = document.getElementById("fechaSeleccionada").value;

                    if (!horarioSeleccionado) {
                        alert("Por favor, seleccione un horario antes de registrar la cita.");
                        return false; // Impide que el formulario se envíe
                    }

                    if (!fechaSeleccionada) {
                        alert("Por favor, seleccione una fecha.");
                        return false; // Impide que el formulario se envíe
                    }

                    console.log("Fecha a enviar:", fechaSeleccionada); // Verifica el valor de la fecha
                    return true; // Permite que el formulario se envíe
                }
            </script>
        </div>
    </div>
</div>





<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.min.js"></script>
</body>


<footer class="bg-dark text-white text-center mt-5 py-4">
  <h5>Agendame</h5>
  <ul class="list-unstyled d-flex justify-content-center mb-3">
    <li class="mx-3"><a href="#about" class="text-white text-decoration-none">Acerca de</a></li>
    <li class="mx-3"><a href="#services" class="text-white text-decoration-none">Servicios</a></li>
    <li class="mx-3"><a href="#contact" class="text-white text-decoration-none">Contacto</a></li>
  </ul>
  <ul class="list-unstyled d-flex justify-content-center mb-3">
    <li class="mx-3"><a href="https://www.facebook.com" target="_blank" class="text-white"><i class="bi bi-facebook"></i></a></li>
    <li class="mx-3"><a href="https://www.twitter.com" target="_blank" class="text-white"><i class="bi bi-twitter"></i></a></li>
    <li class="mx-3"><a href="https://www.instagram.com" target="_blank" class="text-white"><i class="bi bi-instagram"></i></a></li>
  </ul>
  <p class="mb-0">© 2024 Nombre de tu Sitio Web. Todos los derechos reservados.</p>
</footer>
</html>
</html>
