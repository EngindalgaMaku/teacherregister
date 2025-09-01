use actix_web::{web, App, HttpResponse, HttpServer, Result, middleware::Logger};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::sync::{Arc, Mutex};

#[derive(Serialize, Deserialize, Clone)]
struct TeacherInfo {
    ip_address: String,
    port: u16,
    last_updated: String,
}

type TeacherRegistry = Arc<Mutex<HashMap<String, TeacherInfo>>>;

#[derive(Deserialize)]
struct RegisterRequest {
    teacher_id: String,
    ip_address: String,
    port: u16,
}

async fn register_teacher(
    data: web::Json<RegisterRequest>,
    registry: web::Data<TeacherRegistry>,
) -> Result<HttpResponse> {
    let teacher_info = TeacherInfo {
        ip_address: data.ip_address.clone(),
        port: data.port,
        last_updated: chrono::Utc::now().to_rfc3339(),
    };

    let mut registry_map = registry.lock().unwrap();
    registry_map.insert(data.teacher_id.clone(), teacher_info);

    println!("Registered teacher {} at {}:{}", data.teacher_id, data.ip_address, data.port);
    
    Ok(HttpResponse::Ok().json("Teacher registered successfully"))
}

async fn get_teacher(
    teacher_id: web::Path<String>,
    registry: web::Data<TeacherRegistry>,
) -> Result<HttpResponse> {
    let registry_map = registry.lock().unwrap();
    
    if let Some(teacher_info) = registry_map.get(teacher_id.as_str()) {
        Ok(HttpResponse::Ok().json(teacher_info))
    } else {
        Ok(HttpResponse::NotFound().json("Teacher not found"))
    }
}

async fn list_teachers(
    registry: web::Data<TeacherRegistry>,
) -> Result<HttpResponse> {
    let registry_map = registry.lock().unwrap();
    Ok(HttpResponse::Ok().json(&*registry_map))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();
    
    let registry: TeacherRegistry = Arc::new(Mutex::new(HashMap::new()));

    println!("Starting Teacher Registry API on port 8082...");
    
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(registry.clone()))
            .wrap(Logger::default())
            .route("/register", web::post().to(register_teacher))
            .route("/teacher/{teacher_id}", web::get().to(get_teacher))
            .route("/teachers", web::get().to(list_teachers))
    })
    .bind("0.0.0.0:8082")?
    .run()
    .await
}