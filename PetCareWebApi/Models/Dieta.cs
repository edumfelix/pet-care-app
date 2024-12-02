using PetCareWebApi.Models.Base;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace PetCareWebApi.Models
    {
    [Table("dieta")]
    public class Dieta : BaseEntity
        {
            [Column("idConsulta")]
            [ForeignKey("Consulta")]
            [Required]
            public long? IdConsulta { get; set; }

            [Column("refeicoes")]
            [Required]
            public string RefeicoesJson { get; set; } = "{}";

            [NotMapped]
            public Dictionary<string, string> Refeicoes
            {
                get => JsonConvert.DeserializeObject<Dictionary<string, string>>(RefeicoesJson) ?? new Dictionary<string, string>();
                set => RefeicoesJson = JsonConvert.SerializeObject(value ?? new Dictionary<string, string>());
            }
        }
    }
