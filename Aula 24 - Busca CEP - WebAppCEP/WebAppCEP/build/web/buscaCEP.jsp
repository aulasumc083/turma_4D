<%-- 
    Document   : buscaCEP
    Created on : 18 de nov. de 2025, 20:16:44
    Author     : alunocmc
--%>

<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URI"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.json.JSONObject"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consulta CEP</title>
    </head>
    <body>
        <h2>Consulta CEP</h2>        
        <%
            // 0. Pegar o cep do html
            String cep = request.getParameter("cep");
            if (cep != null && !cep.trim().isEmpty() ){
                String urlCEP = "https://viacep.com.br/ws/" + cep + "/json/";
                
                //1. Chamar o ws
                try {
                    URL url = URI.create(urlCEP).toURL();
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("GET");
                    
                    int responseCode = conn.getResponseCode();
                    
                    if (responseCode == HttpURLConnection.HTTP_OK) { //Código 200
                        //2. Tratar a resposta - Ler a resposta
                        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                        String inputLine;
                        StringBuilder resp = new StringBuilder();
                        
                        while((inputLine = in.readLine()) != null){
                            resp.append(inputLine);
                        }
                        in.close();
                        
                        //3. Processa o Json
                        JSONObject json = new JSONObject(resp.toString());
                             
                        if (json.has("erro")){
                            out.print("CEP " + cep + " não encontrado! ");
                        }else{
                            String logradouro = json.getString("logradouro");
                            String bairro = json.getString("bairro");
                            String localidade = json.getString("localidade");
                            String uf = json.getString("uf");
                            String estado = json.getString("estado");
                            String regiao = json.getString("regiao");
                            String ibge = json.getString("ibge");
                            String ddd = json.getString("ddd");

                            //4. Exibir na tela ou popular um objeto Endereco
                            %>
                                <h3> Resultado da consulta </h3>
                                <p>CEP: <%=json.getString("cep")%> </p>
                                <p>Logradouro: <%=json.getString("logradouro")%> </p>
                                <p>Bairro: <%=json.getString("bairro")%> </p>
                                <p>Localidade: <%=json.getString("localidade")%> </p>
                                <p>UF: <%=json.getString("uf")%> </p>
                                <p>Estado: <%=json.getString("estado")%> </p>
                                <p>Regiao: <%=json.getString("regiao")%> </p>
                                <p>IBGE: <%=json.getString("ibge")%> </p>
                                <p>DDD: <%=json.getString("ddd")%> </p>                           
                            <%                        
                        }
                    }                   
                } catch (Exception e) {
                    out.print("erro: " + e);                
                }
            }        
        %>
    </body>
</html>
