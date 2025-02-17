using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using PetCareWebApi;
using PetCareWebApi.Config;
using PetCareWebApi.Data;
using PetCareWebApi.Models;
using PetCareWebApi.Patterns.Observer.Base;
using PetCareWebApi.Patterns.Observer.Interfaces;
using PetCareWebApi.Patterns.Observer.Observers;
using PetCareWebApi.Repository;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("PsqlConnection");

builder.Services.AddDbContext<AppDbContext>(options => options.UseNpgsql(connectionString));

builder.Configuration.GetValue<string>("JWT_SECRET");

IMapper mapper = MappingConfig.RegisterMaps().CreateMapper();
builder.Services.AddSingleton(mapper);
builder.Services.AddSingleton<NotificationSubject>(
//provider =>
//{
    //var subject = new NotificationSubject();

    // Registrando os observadores como IObserver
    //var emailObserver = provider.GetRequiredService<EmailNotificationObserver>();
    //var horarioObserver = provider.GetRequiredService<HorarioUpdateObserver>();

    //subject.Attach(emailObserver);
    //subject.Attach(horarioObserver);

    //return subject;
//}
);

builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

builder.Services.AddScoped<IHorarioConsultaRepository, HorarioConsultaRepository>();
builder.Services.AddScoped<IConsultaRepository, ConsultaRepository>();
builder.Services.AddScoped<IObserver, EmailNotificationObserver>();
builder.Services.AddScoped<IObserver, HorarioUpdateObserver>();

builder.Services.AddControllers();

// Adicionando serviços de autenticação JWT
builder.Services.AddAuthentication("Bearer")
    .AddJwtBearer(options =>
    {
        options.RequireHttpsMetadata = false; // Mudar para true em produção
        options.SaveToken = true;
        options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
        {
            ValidateIssuer = false, // Pode ser configurado se necessário
            ValidateAudience = false, // Pode ser configurado se necessário
            ValidateLifetime = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Settings.Secret))
        };
    });

// Adicionando o serviço de autorização
builder.Services.AddAuthorization();

builder.Services
    .AddIdentityApiEndpoints<User>()
    .AddEntityFrameworkStores<AppDbContext>();

builder.Services.AddCors();

builder.Services.AddControllers();

// Swagger Configuração
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Middleware da autenticação JWT
app.UseAuthentication();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors(options =>
    options.SetIsOriginAllowed(origin => new Uri(origin).Host == "localhost")
           .AllowAnyMethod()
           .AllowAnyHeader()
           .AllowCredentials());

app.UseAuthorization();

app.MapIdentityApi<User>();

app.MapPost("/logout", async (SignInManager<User> signInManager, [FromBody] object empty) =>
{
    await signInManager.SignOutAsync();
    return Results.Ok();
});

app.MapGet("/", () => "Hello World!").RequireAuthorization();

app.MapControllers();

app.Run();
