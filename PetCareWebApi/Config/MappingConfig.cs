using PetCareWebApi.Controllers.Data.ValueObject;
using PetCareWebApi.Models;
using AutoMapper;

namespace PetCareWebApi.Config
{
    public class MappingConfig
    {
        public static MapperConfiguration RegisterMaps()
        {
            var mappingConfig = new MapperConfiguration(config =>
            {
                config.CreateMap<ConsultaVO, Consulta>();
                config.CreateMap<Consulta, ConsultaVO>();

                config.CreateMap<HorarioConsultaVO, HorarioConsulta>();
                config.CreateMap<HorarioConsulta, HorarioConsultaVO>();
            });
            return mappingConfig;
        }
    }
}